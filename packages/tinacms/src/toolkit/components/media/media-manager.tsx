import React from 'react'
import { useEffect, useState } from 'react'
import { useCMS } from '../../react-tinacms/use-cms'
import {
  BiArrowToBottom,
  BiCloudUpload,
  BiError,
  BiFolder,
  BiGridAlt,
  BiLinkExternal,
  BiListUl,
  BiX,
} from 'react-icons/bi'
import { Modal, ModalBody, FullscreenModal } from '@toolkit/react-modals'
import { BiFile } from 'react-icons/bi'
import {
  MediaList,
  Media,
  MediaListOffset,
  MediaListError,
} from '@toolkit/core'
import { Button, IconButton } from '@toolkit/styles'
import * as dropzone from 'react-dropzone'
import type { FileError } from 'react-dropzone'
import { CursorPaginator } from './pagination'
import { ListMediaItem, GridMediaItem } from './media-item'
import { Breadcrumb } from './breadcrumb'
import { LoadingDots } from '@toolkit/form-builder'
import { IoMdRefresh } from 'react-icons/io'
import { CloseIcon, TrashIcon } from '@toolkit/icons'
import {
  absoluteImgURL,
  DEFAULT_MEDIA_UPLOAD_TYPES,
  dropzoneAcceptFromString,
  isImage,
} from './utils'
import { DeleteModal, NewFolderModal } from './modal'
import { CopyField } from './copy-field'
import { createContext, useContext } from 'react'
const { useDropzone } = dropzone
// Can not use path.join on the frontend
const join = function (...parts) {
  // From: https://stackoverflow.com/questions/29855098/is-there-a-built-in-javascript-function-similar-to-os-path-join
  /* This function takes zero or more strings, which are concatenated
  together to form a path or URL, which is returned as a string. This
  function intelligently adds and removes slashes as required, and is
  aware that `file` URLs will contain three adjacent slashes. */

  const [first, last, slash] = [0, parts.length - 1, '/']

  const matchLeadingSlash = new RegExp('^' + slash)
  const matchTrailingSlash = new RegExp(slash + '$')

  parts = parts.map(function (part, index) {
    if (index === first && part === 'file://') return part

    if (index > first) part = part.replace(matchLeadingSlash, '')

    if (index < last) part = part.replace(matchTrailingSlash, '')

    return part
  })

  return parts.join(slash)
}

export interface MediaRequest {
  directory?: string
  onSelect?(_media: Media): void
  close?(): void
  allowDelete?: boolean
}

export function MediaManager() {
  const cms = useCMS()

  const [request, setRequest] = useState<MediaRequest | undefined>()

  useEffect(() => {
    return cms.events.subscribe('media:open', ({ type, ...request }) => {
      setRequest(request)
    })
  }, [])

  if (!request) return null

  const close = () => setRequest(undefined)

  return (
    <Modal>
      <FullscreenModal>
        <div className="flex items-center justify-between w-full px-5 pt-3 m-0 bg-gray-50">
          <h2 className="block m-0 font-sans text-base font-medium leading-none text-gray-500 truncate">
            Media Manager
          </h2>
          <div
            onClick={close}
            className="flex items-center transition-colors duration-100 ease-out cursor-pointer fill-gray-400 hover:fill-gray-700"
          >
            <CloseIcon className="w-6 h-auto" />
          </div>
        </div>
        <ModalBody className="flex flex-col h-full">
          <MediaPicker {...request} close={close} />
        </ModalBody>
      </FullscreenModal>
    </Modal>
  )
}

type MediaListState = 'loading' | 'loaded' | 'error' | 'not-configured'

const defaultListError = new MediaListError({
  title: 'Error fetching media',
  message: 'Something went wrong while requesting the resource.',
  docsLink: 'https://tina.io/docs/media/#media-store',
})

export function MediaPicker({
  allowDelete,
  onSelect,
  close,
  ...props
}: MediaRequest) {
  const cms = useCMS()
  const [listState, setListState] = useState<MediaListState>(() => {
    if (cms.media.isConfigured) return 'loading'
    return 'not-configured'
  })

  const [deleteModalOpen, setDeleteModalOpen] = React.useState(false)
  const [newFolderModalOpen, setNewFolderModalOpen] = React.useState(false)
  const [listError, setListError] = useState<MediaListError>(defaultListError)
  const [directory, setDirectory] = useState<string | undefined>(
    props.directory
  )

  const [list, setList] = useState<MediaList>({
    items: [],
    nextOffset: undefined,
  })

  const [viewMode, setViewMode] = useState<'grid' | 'list'>('grid')
  const [activeItem, setActiveItem] = useState<Media | false>(false)
  const closePreview = () => setActiveItem(false)

  /**
   * current offset is last element in offsetHistory[]
   * control offset by pushing/popping to offsetHistory
   */
  const [offsetHistory, setOffsetHistory] = useState<MediaListOffset[]>([])
  const [loadingText, setLoadingText] = useState('')
  const offset = offsetHistory[offsetHistory.length - 1]
  const resetOffset = () => setOffsetHistory([])
  const navigateNext = () => {
    if (!list.nextOffset) return
    setOffsetHistory([...offsetHistory, list.nextOffset])
  }
  const navigatePrev = () => {
    const offsets = offsetHistory.slice(0, offsetHistory.length - 1)
    setOffsetHistory(offsets)
  }
  const hasPrev = offsetHistory.length > 0
  const hasNext = !!list.nextOffset

  function loadMedia() {
    setListState('loading')
    cms.media
      .list({
        offset,
        limit: cms.media.pageSize,
        directory,
        thumbnailSizes: [
          { w: 75, h: 75 },
          { w: 400, h: 400 },
          { w: 1000, h: 1000 },
        ],
      })
      .then((list) => {
        setList(list)
        setListState('loaded')
      })
      .catch((e) => {
        console.error(e)
        if (e.ERR_TYPE === 'MediaListError') {
          setListError(e)
        } else {
          setListError(defaultListError)
        }
        setListState('error')
      })
  }

  useEffect(() => {
    if (!cms.media.isConfigured) return
    loadMedia()

    return cms.events.subscribe(
      ['media:delete:success', 'media:pageSize'],
      loadMedia
    )
  }, [offset, directory, cms.media.isConfigured])

  const onClickMediaItem = (item: Media) => {
    if (!item) {
      setActiveItem(false)
    } else if (item.type === 'dir') {
      // Only join when there is a directory to join to
      setDirectory(
        item.directory === '.' || item.directory === ''
          ? item.filename
          : join(item.directory, item.filename)
      )
      resetOffset()
    } else {
      setActiveItem(item)
    }
  }

  let deleteMediaItem: (_item: Media) => void
  if (allowDelete) {
    deleteMediaItem = (item: Media) => {
      cms.media.delete(item)
    }
  }

  let selectMediaItem: (_item: Media) => void

  if (onSelect) {
    selectMediaItem = (item: Media) => {
      onSelect(item)
      if (close) close()
    }
  }

  const [uploading, setUploading] = useState(false)
  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: dropzoneAcceptFromString(
      cms.media.accept || DEFAULT_MEDIA_UPLOAD_TYPES
    ),
    multiple: true,
    onDrop: async (files, fileRejections) => {
      try {
        setUploading(true)
        const mediaItems = await cms.media.persist(
          files.map((file) => {
            return {
              directory: directory || '/',
              file,
            }
          })
        )

        // Codes here https://github.com/react-dropzone/react-dropzone/blob/c36ab5bd8b8fd74e2074290d80e3ecb93d26b014/typings/react-dropzone.d.ts#LL13-L18C2
        const errorCodes = {
          'file-invalid-type': 'Invalid file type',
          'file-too-large': 'File too large',
          'file-too-small': 'File too small',
          'too-many-files': 'Too many files',
        }

        const printError = (error: FileError) => {
          const message = errorCodes[error.code]
          if (message) {
            return message
          }
          console.error(error)
          return 'Unknown error'
        }

        // Upload Failed
        if (fileRejections.length > 0) {
          const messages = []
          fileRejections.map((fileRejection) => {
            messages.push(
              `${fileRejection.file.name}: ${fileRejection.errors
                .map((error) => printError(error))
                .join(', ')}`
            )
          })
          cms.alerts.error(() => {
            return (
              <>
                Upload Failed. <br />
                {messages.join('. ')}.
              </>
            )
          })
        }
        // if there are media items, set the first one as active and prepend all the items to the list
        if (mediaItems.length !== 0) {
          setActiveItem(mediaItems[0])
          setList((mediaList) => {
            return {
              items: [
                // all of the newly added items are new
                ...mediaItems.map((x) => ({ ...x, new: true })),
                ...mediaList.items,
              ],
              nextOffset: mediaList.nextOffset,
            }
          })
        }
      } catch {
        // TODO: Events get dispatched already. Does anything else need to happen?
      }
      setUploading(false)
    },
  })

  const { onClick, ...rootProps } = getRootProps()

  function disableScrollBody() {
    const body = document?.body
    body.style.overflow = 'hidden'

    return () => {
      body.style.overflow = 'auto'
    }
  }

  useEffect(disableScrollBody, [])

  if (listState === 'loading' || uploading) {
    return <LoadingMediaList extraText={loadingText} />
  }

  if (listState === 'not-configured') {
    return (
      <DocsLink
        title="No Media Store Configured"
        message="To use the media manager, you need to configure a Media Store."
        docsLink="https://tina.io/docs/reference/media/overview/"
      />
    )
  }

  if (listState === 'error') {
    const { title, message, docsLink } = listError
    return <DocsLink title={title} message={message} docsLink={docsLink} />
  }

  return (
    <>
      {deleteModalOpen && (
        <DeleteModal
          filename={activeItem ? activeItem.filename : ''}
          deleteFunc={() => {
            if (activeItem) {
              deleteMediaItem(activeItem)
              setActiveItem(false)
            }
          }}
          close={() => setDeleteModalOpen(false)}
        />
      )}
      {newFolderModalOpen && (
        <NewFolderModal
          onSubmit={(name) => {
            setDirectory((oldDir) => {
              if (oldDir) {
                return join(oldDir, name)
              } else {
                return name
              }
            })
            resetOffset()
          }}
          close={() => setNewFolderModalOpen(false)}
        />
      )}

      <MediaPickerWrap>
        <SyncStatusContainer>
          <div className="flex flex-wrap items-center flex-shrink-0 gap-4 px-5 py-3 border-b shadow-sm bg-gray-50 border-gray-150">
            <div className="flex items-center flex-1 gap-4">
              <ViewModeToggle viewMode={viewMode} setViewMode={setViewMode} />
              <Breadcrumb directory={directory} setDirectory={setDirectory} />
            </div>

            {cms.media.store.isStatic ? null : (
              <div className="flex flex-wrap items-center gap-4">
                <Button
                  busy={false}
                  variant="white"
                  onClick={loadMedia}
                  className="whitespace-nowrap"
                >
                  Refresh
                  <IoMdRefresh className="w-6 h-full ml-2 text-blue-500 opacity-70" />
                </Button>
                <Button
                  busy={false}
                  variant="white"
                  onClick={() => {
                    setNewFolderModalOpen(true)
                  }}
                  className="whitespace-nowrap"
                >
                  New Folder
                  <BiFolder className="w-6 h-full ml-2 text-blue-500 opacity-70" />
                </Button>
                <UploadButton onClick={onClick} uploading={uploading} />
              </div>
            )}
          </div>

          <div className="flex h-full overflow-hidden bg-white">
            <div className="flex w-full flex-col h-full @container">
              <ul
                {...rootProps}
                className={`h-full grow overflow-y-auto transition duration-150 ease-out bg-gradient-to-b from-gray-50/50 to-gray-50 ${
                  list.items.length === 0 ||
                  (viewMode === 'list' &&
                    'w-full flex flex-1 flex-col justify-start -mb-px')
                } ${
                  list.items.length > 0 &&
                  viewMode === 'grid' &&
                  'w-full p-4 gap-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4 4xl:grid-cols-6 6xl:grid-cols-9 auto-rows-auto content-start justify-start'
                } ${isDragActive ? `border-2 border-blue-500 rounded-lg` : ``}`}
              >
                <input {...getInputProps()} />

                {listState === 'loaded' && list.items.length === 0 && (
                  <EmptyMediaList />
                )}

                {viewMode === 'list' &&
                  list.items.map((item: Media) => (
                    <ListMediaItem
                      key={item.id}
                      item={item}
                      onClick={onClickMediaItem}
                      active={activeItem && activeItem.id === item.id}
                    />
                  ))}

                {viewMode === 'grid' &&
                  list.items.map((item: Media) => (
                    <GridMediaItem
                      key={item.id}
                      item={item}
                      onClick={onClickMediaItem}
                      active={activeItem && activeItem.id === item.id}
                    />
                  ))}
              </ul>

              <div className="z-10 px-5 py-3 border-t shadow-sm bg-gradient-to-r to-gray-50/50 from-gray-50 shrink-0 grow-0 border-gray-150">
                <CursorPaginator
                  hasNext={hasNext}
                  navigateNext={navigateNext}
                  hasPrev={hasPrev}
                  navigatePrev={navigatePrev}
                />
              </div>
            </div>

            <ActiveItemPreview
              activeItem={activeItem}
              close={closePreview}
              selectMediaItem={selectMediaItem}
              allowDelete={cms.media.store.isStatic ? false : allowDelete}
              deleteMediaItem={() => {
                setDeleteModalOpen(true)
              }}
            />
          </div>
        </SyncStatusContainer>
      </MediaPickerWrap>
    </>
  )
}

const ActiveItemPreview = ({
  activeItem,
  close,
  selectMediaItem,
  deleteMediaItem,
  allowDelete,
}) => {
  const thumbnail = activeItem ? (activeItem.thumbnails || {})['1000x1000'] : ''
  return (
    <div
      className={`shrink-0 h-full flex flex-col items-start gap-3 overflow-y-auto bg-white border-l border-gray-100 bg-white shadow-md transition ease-out duration-150 ${
        activeItem
          ? `p-4 opacity-100 w-[35%] max-w-[560px] min-w-[240px]`
          : `translate-x-8 opacity-0 w-[0px]`
      }`}
    >
      {activeItem && (
        <>
          <div className="flex items-center justify-between w-full gap-2 grow-0 shrink-0">
            <h3 className="flex-1 block w-full max-w-full text-lg text-gray-600 break-words truncate">
              {activeItem.filename}
            </h3>
            <IconButton
              variant="ghost"
              className="group grow-0 shrink-0"
              onClick={close}
            >
              <BiX
                className={`w-7 h-auto text-gray-500 opacity-50 group-hover:opacity-100 transition duration-150 ease-out`}
              />
            </IconButton>
          </div>
          {isImage(thumbnail) ? (
            <div className="w-full max-h-[75%]">
              <img
                className="block object-contain object-center max-w-full max-h-full m-auto overflow-hidden border border-gray-100 rounded-md shadow"
                src={thumbnail}
                alt={activeItem.filename}
              />
            </div>
          ) : (
            <span className="p-3 overflow-hidden border border-gray-100 rounded-md shadow bg-gray-50">
              <BiFile className="h-auto w-14 fill-gray-300" />
            </span>
          )}
          <div className="flex flex-col items-start justify-start w-full h-full gap-3 grow shrink">
            <CopyField value={absoluteImgURL(activeItem.src)} label="URL" />
          </div>
          <div className="flex flex-col items-start justify-end w-full shrink-0">
            <div className="flex w-full gap-3">
              {selectMediaItem && (
                <Button
                  size="medium"
                  variant="primary"
                  className="grow"
                  onClick={() => selectMediaItem(activeItem)}
                >
                  Insert
                  <BiArrowToBottom className="ml-1 -mr-0.5 w-6 h-auto text-white opacity-70" />
                </Button>
              )}
              {allowDelete && (
                <Button
                  variant="white"
                  size="medium"
                  className="grow max-w-[40%]"
                  onClick={deleteMediaItem}
                >
                  Delete
                  <TrashIcon className="ml-1 -mr-0.5 w-6 h-auto text-red-500 opacity-70" />
                </Button>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  )
}

const UploadButton = ({ onClick, uploading }: any) => {
  return (
    <Button
      variant="primary"
      size="custom"
      className="h-10 px-6 text-sm"
      busy={uploading}
      onClick={onClick}
    >
      {uploading ? (
        <LoadingDots />
      ) : (
        <>
          Upload <BiCloudUpload className="w-6 h-full ml-2 opacity-70" />
        </>
      )}
    </Button>
  )
}

const LoadingMediaList = (props) => {
  const { extraText, ...rest } = props
  return (
    <div
      className="flex flex-col items-center justify-center w-full h-full"
      {...rest}
    >
      {extraText && <p>{props}</p>}
      <LoadingDots color={'var(--tina-color-primary)'} />
    </div>
  )
}

const MediaPickerWrap = ({ children }) => {
  return (
    <div className="relative flex flex-col flex-1 h-full text-gray-700 outline-none bg-gray-50 active:outline-none focus:outline-none">
      {children}
    </div>
  )
}

interface SyncStatusContextProps {
  syncStatus: 'loading' | 'synced' | 'needs-sync'
}

const SyncStatusContext = createContext<SyncStatusContextProps | undefined>(
  undefined
)

const SyncStatusContainer = ({ children }) => {
  const cms = useCMS()
  const isLocal = cms.api.tina.isLocalMode

  const tinaMedia = cms.api.tina.schema.schema?.config?.media?.tina
  const hasTinaMedia = !!(tinaMedia?.mediaRoot || tinaMedia?.publicFolder)

  const doCheckSyncStatus = hasTinaMedia && !isLocal
  const [syncStatus, setSyncStatus] = useState<
    'loading' | 'synced' | 'needs-sync'
  >(doCheckSyncStatus ? 'loading' : 'synced')
  //

  useEffect(() => {
    const checkSyncStatus = async () => {
      if (doCheckSyncStatus) {
        const project = await cms.api.tina.getProject()

        setSyncStatus(project.mediaBranch ? 'synced' : 'needs-sync')
      }
    }

    if (!cms.media.store.isStatic) {
      checkSyncStatus()
    }
  }, [])

  return syncStatus == 'needs-sync' ? (
    <div className="flex items-center justify-center h-full p-6 bg-gradient-to-t from-gray-200 to-transparent">
      <div className="px-4 py-3 mx-auto mb-12 border border-yellow-200 rounded-lg shadow-sm lg:px-6 lg:py-4 bg-gradient-to-r from-yellow-50 to-yellow-100">
        <div className="flex items-start gap-2 sm:items-center">
          <BiError
            className={`w-7 h-auto flex-shrink-0 text-yellow-400 -mt-px`}
          />
          <div
            className={`flex-1 flex flex-col items-start gap-0.5 text-base text-yellow-700`}
          >
            Media needs to be turned on for this project.
            <a
              className="flex items-center justify-start gap-1 font-medium text-blue-500 underline transition-all duration-150 ease-out hover:text-blue-400 hover:underline decoration-blue-200 hover:decoration-blue-400"
              target="_blank"
              href={`${cms.api.tina.appDashboardLink}/media`}
            >
              Sync Your Media In Tina Cloud.
              <BiLinkExternal className={`w-5 h-auto flex-shrink-0`} />
            </a>
          </div>
        </div>
      </div>
    </div>
  ) : (
    <SyncStatusContext.Provider value={{ syncStatus }}>
      {children}
    </SyncStatusContext.Provider>
  )
}

const useSyncStatus = () => {
  const context = useContext(SyncStatusContext)
  if (!context) {
    throw new Error('useSyncStatus must be used within a SyncStatusProvider')
  }
  return context
}

const EmptyMediaList = () => {
  const { syncStatus } = useSyncStatus()
  return (
    <div className={`p-12 text-xl opacity-50 text-center`}>
      {syncStatus == 'synced' ? 'Drag and drop assets here' : 'Loading...'}
    </div>
  )
}

const DocsLink = ({ title, message, docsLink, ...props }) => {
  return (
    <div className="flex flex-col justify-center text-center h-3/4" {...props}>
      <h2 className="mb-3 text-xl text-gray-600">{title}</h2>
      <div className="mb-3 text-base text-gray-700">{message}</div>
      <a
        href={docsLink}
        target="_blank"
        rel="noreferrer noopener"
        className="font-bold text-blue-500 transition-all duration-150 ease-out hover:text-blue-600 hover:underline"
      >
        Learn More
      </a>
    </div>
  )
}

const ViewModeToggle = ({ viewMode, setViewMode }) => {
  const toggleClasses = {
    base: 'relative whitespace-nowrap flex items-center justify-center flex-1 block font-medium text-base py-1 transition-all ease-out duration-150 border',
    active:
      'bg-white text-blue-500 shadow-inner border-gray-50 border-t-gray-100',
    inactive: 'bg-gray-50 text-gray-400 shadow border-gray-100 border-t-white',
  }

  return (
    <div
      className={`grow-0 flex justify-between rounded-md border border-gray-100`}
    >
      <button
        className={`${toggleClasses.base} px-2.5 rounded-l-md ${
          viewMode === 'grid' ? toggleClasses.active : toggleClasses.inactive
        }`}
        onClick={() => {
          setViewMode('grid')
        }}
      >
        <BiGridAlt className="w-6 h-full opacity-70" />
      </button>
      <button
        className={`${toggleClasses.base} px-2 rounded-r-md ${
          viewMode === 'list' ? toggleClasses.active : toggleClasses.inactive
        }`}
        onClick={() => {
          setViewMode('list')
        }}
      >
        <BiListUl className="w-8 h-full opacity-70" />
      </button>
    </div>
  )
}
