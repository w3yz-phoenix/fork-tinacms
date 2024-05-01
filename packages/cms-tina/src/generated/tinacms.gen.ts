import { useQuery, useSuspenseQuery, useInfiniteQuery, useSuspenseInfiniteQuery, UseQueryOptions, UseSuspenseQueryOptions, UseInfiniteQueryOptions, InfiniteData, UseSuspenseInfiniteQueryOptions } from '@tanstack/react-query';
import { fetcher } from '../fetcher';

/* template-start: disable-eslint */
/* eslint-disable */
/* template-end: disable-eslint */


/* template-start: common-scalars */
import type { CustomScalars } from '@w3yz/types';
/* template-end: common-scalars */

export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
export type FieldWrapper<T> = T;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
  JSON: { input: CustomScalars["JSONValue"]; output: CustomScalars["JSONValue"]; }
  /** References another document, used as a foreign key */
  Reference: { input: CustomScalars["AnyObject"]; output: CustomScalars["AnyObject"]; }
};

export type TinaGraphql_Collection = {
  __typename?: 'Collection';
  documents: FieldWrapper<TinaGraphql_DocumentConnection>;
  fields?: Maybe<Array<Maybe<FieldWrapper<Scalars['JSON']['output']>>>>;
  format?: Maybe<FieldWrapper<Scalars['String']['output']>>;
  label?: Maybe<FieldWrapper<Scalars['String']['output']>>;
  matches?: Maybe<FieldWrapper<Scalars['String']['output']>>;
  name: FieldWrapper<Scalars['String']['output']>;
  path: FieldWrapper<Scalars['String']['output']>;
  slug: FieldWrapper<Scalars['String']['output']>;
  templates?: Maybe<Array<Maybe<FieldWrapper<Scalars['JSON']['output']>>>>;
};


export type TinaGraphql_CollectionDocumentsArgs = {
  after?: InputMaybe<Scalars['String']['input']>;
  before?: InputMaybe<Scalars['String']['input']>;
  filter?: InputMaybe<TinaGraphql_DocumentFilter>;
  first?: InputMaybe<Scalars['Float']['input']>;
  folder?: InputMaybe<Scalars['String']['input']>;
  last?: InputMaybe<Scalars['Float']['input']>;
  sort?: InputMaybe<Scalars['String']['input']>;
};

/** A relay-compliant pagination connection */
export type TinaGraphql_Connection = {
  pageInfo: FieldWrapper<TinaGraphql_PageInfo>;
  totalCount: FieldWrapper<Scalars['Float']['output']>;
};

export type TinaGraphql_Document = {
  _sys?: Maybe<FieldWrapper<TinaGraphql_SystemInfo>>;
  _values: FieldWrapper<Scalars['JSON']['output']>;
  id: FieldWrapper<Scalars['ID']['output']>;
};

export type TinaGraphql_DocumentConnection = TinaGraphql_Connection & {
  __typename?: 'DocumentConnection';
  edges?: Maybe<Array<Maybe<FieldWrapper<TinaGraphql_DocumentConnectionEdges>>>>;
  pageInfo: FieldWrapper<TinaGraphql_PageInfo>;
  totalCount: FieldWrapper<Scalars['Float']['output']>;
};

export type TinaGraphql_DocumentConnectionEdges = {
  __typename?: 'DocumentConnectionEdges';
  cursor: FieldWrapper<Scalars['String']['output']>;
  node?: Maybe<FieldWrapper<TinaGraphql_DocumentNode>>;
};

export type TinaGraphql_DocumentFilter = {
  user?: InputMaybe<TinaGraphql_UserFilter>;
};

export type TinaGraphql_DocumentMutation = {
  user?: InputMaybe<TinaGraphql_UserMutation>;
};

export type TinaGraphql_DocumentNode = TinaGraphql_Folder | TinaGraphql_User;

export type TinaGraphql_DocumentUpdateMutation = {
  relativePath?: InputMaybe<Scalars['String']['input']>;
  user?: InputMaybe<TinaGraphql_UserMutation>;
};

export type TinaGraphql_Folder = {
  __typename?: 'Folder';
  name: FieldWrapper<Scalars['String']['output']>;
  path: FieldWrapper<Scalars['String']['output']>;
};

export type TinaGraphql_Mutation = {
  __typename?: 'Mutation';
  addPendingDocument: FieldWrapper<TinaGraphql_DocumentNode>;
  createDocument: FieldWrapper<TinaGraphql_DocumentNode>;
  createUser: FieldWrapper<TinaGraphql_User>;
  deleteDocument: FieldWrapper<TinaGraphql_DocumentNode>;
  updateDocument: FieldWrapper<TinaGraphql_DocumentNode>;
  updatePassword: FieldWrapper<Scalars['Boolean']['output']>;
  updateUser: FieldWrapper<TinaGraphql_User>;
};


export type TinaGraphql_MutationAddPendingDocumentArgs = {
  collection: Scalars['String']['input'];
  relativePath: Scalars['String']['input'];
  template?: InputMaybe<Scalars['String']['input']>;
};


export type TinaGraphql_MutationCreateDocumentArgs = {
  collection?: InputMaybe<Scalars['String']['input']>;
  params: TinaGraphql_DocumentMutation;
  relativePath: Scalars['String']['input'];
};


export type TinaGraphql_MutationCreateUserArgs = {
  params: TinaGraphql_UserMutation;
  relativePath: Scalars['String']['input'];
};


export type TinaGraphql_MutationDeleteDocumentArgs = {
  collection?: InputMaybe<Scalars['String']['input']>;
  relativePath: Scalars['String']['input'];
};


export type TinaGraphql_MutationUpdateDocumentArgs = {
  collection?: InputMaybe<Scalars['String']['input']>;
  params: TinaGraphql_DocumentUpdateMutation;
  relativePath: Scalars['String']['input'];
};


export type TinaGraphql_MutationUpdatePasswordArgs = {
  password: Scalars['String']['input'];
};


export type TinaGraphql_MutationUpdateUserArgs = {
  params: TinaGraphql_UserMutation;
  relativePath: Scalars['String']['input'];
};

export type TinaGraphql_Node = {
  id: FieldWrapper<Scalars['ID']['output']>;
};

export type TinaGraphql_PageInfo = {
  __typename?: 'PageInfo';
  endCursor: FieldWrapper<Scalars['String']['output']>;
  hasNextPage: FieldWrapper<Scalars['Boolean']['output']>;
  hasPreviousPage: FieldWrapper<Scalars['Boolean']['output']>;
  startCursor: FieldWrapper<Scalars['String']['output']>;
};

export type TinaGraphql_Query = {
  __typename?: 'Query';
  authenticate?: Maybe<FieldWrapper<TinaGraphql_UserUsers>>;
  authorize?: Maybe<FieldWrapper<TinaGraphql_UserUsers>>;
  collection: FieldWrapper<TinaGraphql_Collection>;
  collections: Array<FieldWrapper<TinaGraphql_Collection>>;
  document: FieldWrapper<TinaGraphql_DocumentNode>;
  getOptimizedQuery?: Maybe<FieldWrapper<Scalars['String']['output']>>;
  node: FieldWrapper<TinaGraphql_Node>;
  user: FieldWrapper<TinaGraphql_User>;
  userConnection: FieldWrapper<TinaGraphql_UserConnection>;
};


export type TinaGraphql_QueryAuthenticateArgs = {
  password: Scalars['String']['input'];
  sub: Scalars['String']['input'];
};


export type TinaGraphql_QueryCollectionArgs = {
  collection?: InputMaybe<Scalars['String']['input']>;
};


export type TinaGraphql_QueryDocumentArgs = {
  collection?: InputMaybe<Scalars['String']['input']>;
  relativePath?: InputMaybe<Scalars['String']['input']>;
};


export type TinaGraphql_QueryGetOptimizedQueryArgs = {
  queryString: Scalars['String']['input'];
};


export type TinaGraphql_QueryNodeArgs = {
  id?: InputMaybe<Scalars['String']['input']>;
};


export type TinaGraphql_QueryUserArgs = {
  relativePath?: InputMaybe<Scalars['String']['input']>;
};


export type TinaGraphql_QueryUserConnectionArgs = {
  after?: InputMaybe<Scalars['String']['input']>;
  before?: InputMaybe<Scalars['String']['input']>;
  filter?: InputMaybe<TinaGraphql_UserFilter>;
  first?: InputMaybe<Scalars['Float']['input']>;
  last?: InputMaybe<Scalars['Float']['input']>;
  sort?: InputMaybe<Scalars['String']['input']>;
};

export type TinaGraphql_StringFilter = {
  eq?: InputMaybe<Scalars['String']['input']>;
  exists?: InputMaybe<Scalars['Boolean']['input']>;
  in?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  startsWith?: InputMaybe<Scalars['String']['input']>;
};

export type TinaGraphql_SystemInfo = {
  __typename?: 'SystemInfo';
  basename: FieldWrapper<Scalars['String']['output']>;
  breadcrumbs: Array<FieldWrapper<Scalars['String']['output']>>;
  collection: FieldWrapper<TinaGraphql_Collection>;
  extension: FieldWrapper<Scalars['String']['output']>;
  filename: FieldWrapper<Scalars['String']['output']>;
  path: FieldWrapper<Scalars['String']['output']>;
  relativePath: FieldWrapper<Scalars['String']['output']>;
  template: FieldWrapper<Scalars['String']['output']>;
  title?: Maybe<FieldWrapper<Scalars['String']['output']>>;
};


export type TinaGraphql_SystemInfoBreadcrumbsArgs = {
  excludeExtension?: InputMaybe<Scalars['Boolean']['input']>;
};

export type TinaGraphql_User = TinaGraphql_Document & TinaGraphql_Node & {
  __typename?: 'User';
  _sys: FieldWrapper<TinaGraphql_SystemInfo>;
  _values: FieldWrapper<Scalars['JSON']['output']>;
  id: FieldWrapper<Scalars['ID']['output']>;
  users?: Maybe<Array<Maybe<FieldWrapper<TinaGraphql_UserUsers>>>>;
};

export type TinaGraphql_UserConnection = TinaGraphql_Connection & {
  __typename?: 'UserConnection';
  edges?: Maybe<Array<Maybe<FieldWrapper<TinaGraphql_UserConnectionEdges>>>>;
  pageInfo: FieldWrapper<TinaGraphql_PageInfo>;
  totalCount: FieldWrapper<Scalars['Float']['output']>;
};

export type TinaGraphql_UserConnectionEdges = {
  __typename?: 'UserConnectionEdges';
  cursor: FieldWrapper<Scalars['String']['output']>;
  node?: Maybe<FieldWrapper<TinaGraphql_User>>;
};

export type TinaGraphql_UserFilter = {
  users?: InputMaybe<TinaGraphql_UserUsersFilter>;
};

export type TinaGraphql_UserMutation = {
  users?: InputMaybe<Array<InputMaybe<TinaGraphql_UserUsersMutation>>>;
};

export type TinaGraphql_UserUsers = {
  __typename?: 'UserUsers';
  email?: Maybe<FieldWrapper<Scalars['String']['output']>>;
  name?: Maybe<FieldWrapper<Scalars['String']['output']>>;
  password: FieldWrapper<TinaGraphql_UserUsersPassword>;
  username: FieldWrapper<Scalars['String']['output']>;
};

export type TinaGraphql_UserUsersFilter = {
  email?: InputMaybe<TinaGraphql_StringFilter>;
  name?: InputMaybe<TinaGraphql_StringFilter>;
  username?: InputMaybe<TinaGraphql_StringFilter>;
};

export type TinaGraphql_UserUsersMutation = {
  email?: InputMaybe<Scalars['String']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
  password?: InputMaybe<TinaGraphql_UserUsersPasswordMutation>;
  username?: InputMaybe<Scalars['String']['input']>;
};

export type TinaGraphql_UserUsersPassword = {
  __typename?: 'UserUsersPassword';
  passwordChangeRequired?: Maybe<FieldWrapper<Scalars['Boolean']['output']>>;
  value: FieldWrapper<Scalars['String']['output']>;
};

export type TinaGraphql_UserUsersPasswordMutation = {
  passwordChangeRequired: Scalars['Boolean']['input'];
  value?: InputMaybe<Scalars['String']['input']>;
};

export type TinaGraphql_UserPartsFragment = { __typename: 'User', users?: Array<{ __typename: 'UserUsers', username: string, name?: string | null, email?: string | null, password: { __typename?: 'UserUsersPassword', value: string, passwordChangeRequired?: boolean | null } } | null> | null };

export type TinaGraphql_UserQueryVariables = Exact<{
  relativePath: Scalars['String']['input'];
}>;


export type TinaGraphql_UserQuery = { user: { __typename: 'User', id: string, _sys: { __typename?: 'SystemInfo', filename: string, basename: string, breadcrumbs: Array<string>, path: string, relativePath: string, extension: string }, users?: Array<{ __typename: 'UserUsers', username: string, name?: string | null, email?: string | null, password: { __typename?: 'UserUsersPassword', value: string, passwordChangeRequired?: boolean | null } } | null> | null } };

export type TinaGraphql_UserConnectionQueryVariables = Exact<{
  before?: InputMaybe<Scalars['String']['input']>;
  after?: InputMaybe<Scalars['String']['input']>;
  first?: InputMaybe<Scalars['Float']['input']>;
  last?: InputMaybe<Scalars['Float']['input']>;
  sort?: InputMaybe<Scalars['String']['input']>;
  filter?: InputMaybe<TinaGraphql_UserFilter>;
}>;


export type TinaGraphql_UserConnectionQuery = { userConnection: { __typename?: 'UserConnection', totalCount: number, pageInfo: { __typename?: 'PageInfo', hasPreviousPage: boolean, hasNextPage: boolean, startCursor: string, endCursor: string }, edges?: Array<{ __typename?: 'UserConnectionEdges', cursor: string, node?: { __typename: 'User', id: string, _sys: { __typename?: 'SystemInfo', filename: string, basename: string, breadcrumbs: Array<string>, path: string, relativePath: string, extension: string }, users?: Array<{ __typename: 'UserUsers', username: string, name?: string | null, email?: string | null, password: { __typename?: 'UserUsersPassword', value: string, passwordChangeRequired?: boolean | null } } | null> | null } | null } | null> | null } };


export const TinaGraphql_UserPartsFragmentDoc = `
    fragment UserParts on User {
  __typename
  users {
    __typename
    username
    name
    email
    password {
      value
      passwordChangeRequired
    }
  }
}
    `;
export const TinaGraphql_UserDocument = `
    query user($relativePath: String!) {
  user(relativePath: $relativePath) {
    ... on Document {
      _sys {
        filename
        basename
        breadcrumbs
        path
        relativePath
        extension
      }
      id
    }
    ...UserParts
  }
}
    ${TinaGraphql_UserPartsFragmentDoc}`;

export const useUserQuery = <
      TData = TinaGraphql_UserQuery,
      TError = unknown
    >(
      variables: TinaGraphql_UserQueryVariables,
      options?: Omit<UseQueryOptions<TinaGraphql_UserQuery, TError, TData>, 'queryKey'> & { queryKey?: UseQueryOptions<TinaGraphql_UserQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useQuery<TinaGraphql_UserQuery, TError, TData>(
      {
    queryKey: ['user', variables],
    queryFn: fetcher<TinaGraphql_UserQuery, TinaGraphql_UserQueryVariables>(TinaGraphql_UserDocument, variables),
    ...options
  }
    )};

useUserQuery.document = TinaGraphql_UserDocument;

useUserQuery.getKey = (variables: TinaGraphql_UserQueryVariables) => ['user', variables];

useUserQuery.rootKey = 'user';

export const useSuspenseUserQuery = <
      TData = TinaGraphql_UserQuery,
      TError = unknown
    >(
      variables: TinaGraphql_UserQueryVariables,
      options?: Omit<UseSuspenseQueryOptions<TinaGraphql_UserQuery, TError, TData>, 'queryKey'> & { queryKey?: UseSuspenseQueryOptions<TinaGraphql_UserQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useSuspenseQuery<TinaGraphql_UserQuery, TError, TData>(
      {
    queryKey: ['userSuspense', variables],
    queryFn: fetcher<TinaGraphql_UserQuery, TinaGraphql_UserQueryVariables>(TinaGraphql_UserDocument, variables),
    ...options
  }
    )};

useSuspenseUserQuery.document = TinaGraphql_UserDocument;

useSuspenseUserQuery.getKey = (variables: TinaGraphql_UserQueryVariables) => ['userSuspense', variables];

useSuspenseUserQuery.rootKey = 'user';

export const useInfiniteUserQuery = <
      TData = InfiniteData<TinaGraphql_UserQuery>,
      TError = unknown
    >(
      variables: TinaGraphql_UserQueryVariables,
      options: Omit<UseInfiniteQueryOptions<TinaGraphql_UserQuery, TError, TData>, 'queryKey'> & { queryKey?: UseInfiniteQueryOptions<TinaGraphql_UserQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useInfiniteQuery<TinaGraphql_UserQuery, TError, TData>(
      (() => {
    const { queryKey: optionsQueryKey, ...restOptions } = options;
    return {
      queryKey: optionsQueryKey ?? ['user.infinite', variables],
      queryFn: (metaData) => fetcher<TinaGraphql_UserQuery, TinaGraphql_UserQueryVariables>(TinaGraphql_UserDocument, {...variables, ...(metaData.pageParam ?? {})})(),
      ...restOptions
    }
  })()
    )};

useInfiniteUserQuery.getKey = (variables: TinaGraphql_UserQueryVariables) => ['user.infinite', variables];

useInfiniteUserQuery.rootKey = 'user.infinite';

export const useSuspenseInfiniteUserQuery = <
      TData = InfiniteData<TinaGraphql_UserQuery>,
      TError = unknown
    >(
      variables: TinaGraphql_UserQueryVariables,
      options: Omit<UseSuspenseInfiniteQueryOptions<TinaGraphql_UserQuery, TError, TData>, 'queryKey'> & { queryKey?: UseSuspenseInfiniteQueryOptions<TinaGraphql_UserQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useSuspenseInfiniteQuery<TinaGraphql_UserQuery, TError, TData>(
      (() => {
    const { queryKey: optionsQueryKey, ...restOptions } = options;
    return {
      queryKey: optionsQueryKey ?? ['user.infiniteSuspense', variables],
      queryFn: (metaData) => fetcher<TinaGraphql_UserQuery, TinaGraphql_UserQueryVariables>(TinaGraphql_UserDocument, {...variables, ...(metaData.pageParam ?? {})})(),
      ...restOptions
    }
  })()
    )};

useSuspenseInfiniteUserQuery.getKey = (variables: TinaGraphql_UserQueryVariables) => ['user.infiniteSuspense', variables];

useSuspenseInfiniteUserQuery.rootKey = 'user.infinite';


useUserQuery.fetcher = (variables: TinaGraphql_UserQueryVariables, options?: RequestInit['headers']) => fetcher<TinaGraphql_UserQuery, TinaGraphql_UserQueryVariables>(TinaGraphql_UserDocument, variables, options);

export const TinaGraphql_UserConnectionDocument = `
    query userConnection($before: String, $after: String, $first: Float, $last: Float, $sort: String, $filter: UserFilter) {
  userConnection(
    before: $before
    after: $after
    first: $first
    last: $last
    sort: $sort
    filter: $filter
  ) {
    pageInfo {
      hasPreviousPage
      hasNextPage
      startCursor
      endCursor
    }
    totalCount
    edges {
      cursor
      node {
        ... on Document {
          _sys {
            filename
            basename
            breadcrumbs
            path
            relativePath
            extension
          }
          id
        }
        ...UserParts
      }
    }
  }
}
    ${TinaGraphql_UserPartsFragmentDoc}`;

export const useUserConnectionQuery = <
      TData = TinaGraphql_UserConnectionQuery,
      TError = unknown
    >(
      variables?: TinaGraphql_UserConnectionQueryVariables,
      options?: Omit<UseQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>, 'queryKey'> & { queryKey?: UseQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useQuery<TinaGraphql_UserConnectionQuery, TError, TData>(
      {
    queryKey: variables === undefined ? ['userConnection'] : ['userConnection', variables],
    queryFn: fetcher<TinaGraphql_UserConnectionQuery, TinaGraphql_UserConnectionQueryVariables>(TinaGraphql_UserConnectionDocument, variables),
    ...options
  }
    )};

useUserConnectionQuery.document = TinaGraphql_UserConnectionDocument;

useUserConnectionQuery.getKey = (variables?: TinaGraphql_UserConnectionQueryVariables) => variables === undefined ? ['userConnection'] : ['userConnection', variables];

useUserConnectionQuery.rootKey = 'userConnection';

export const useSuspenseUserConnectionQuery = <
      TData = TinaGraphql_UserConnectionQuery,
      TError = unknown
    >(
      variables?: TinaGraphql_UserConnectionQueryVariables,
      options?: Omit<UseSuspenseQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>, 'queryKey'> & { queryKey?: UseSuspenseQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useSuspenseQuery<TinaGraphql_UserConnectionQuery, TError, TData>(
      {
    queryKey: variables === undefined ? ['userConnectionSuspense'] : ['userConnectionSuspense', variables],
    queryFn: fetcher<TinaGraphql_UserConnectionQuery, TinaGraphql_UserConnectionQueryVariables>(TinaGraphql_UserConnectionDocument, variables),
    ...options
  }
    )};

useSuspenseUserConnectionQuery.document = TinaGraphql_UserConnectionDocument;

useSuspenseUserConnectionQuery.getKey = (variables?: TinaGraphql_UserConnectionQueryVariables) => variables === undefined ? ['userConnectionSuspense'] : ['userConnectionSuspense', variables];

useSuspenseUserConnectionQuery.rootKey = 'userConnection';

export const useInfiniteUserConnectionQuery = <
      TData = InfiniteData<TinaGraphql_UserConnectionQuery>,
      TError = unknown
    >(
      variables: TinaGraphql_UserConnectionQueryVariables,
      options: Omit<UseInfiniteQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>, 'queryKey'> & { queryKey?: UseInfiniteQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useInfiniteQuery<TinaGraphql_UserConnectionQuery, TError, TData>(
      (() => {
    const { queryKey: optionsQueryKey, ...restOptions } = options;
    return {
      queryKey: optionsQueryKey ?? variables === undefined ? ['userConnection.infinite'] : ['userConnection.infinite', variables],
      queryFn: (metaData) => fetcher<TinaGraphql_UserConnectionQuery, TinaGraphql_UserConnectionQueryVariables>(TinaGraphql_UserConnectionDocument, {...variables, ...(metaData.pageParam ?? {})})(),
      ...restOptions
    }
  })()
    )};

useInfiniteUserConnectionQuery.getKey = (variables?: TinaGraphql_UserConnectionQueryVariables) => variables === undefined ? ['userConnection.infinite'] : ['userConnection.infinite', variables];

useInfiniteUserConnectionQuery.rootKey = 'userConnection.infinite';

export const useSuspenseInfiniteUserConnectionQuery = <
      TData = InfiniteData<TinaGraphql_UserConnectionQuery>,
      TError = unknown
    >(
      variables: TinaGraphql_UserConnectionQueryVariables,
      options: Omit<UseSuspenseInfiniteQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>, 'queryKey'> & { queryKey?: UseSuspenseInfiniteQueryOptions<TinaGraphql_UserConnectionQuery, TError, TData>['queryKey'] }
    ) => {
    
    return useSuspenseInfiniteQuery<TinaGraphql_UserConnectionQuery, TError, TData>(
      (() => {
    const { queryKey: optionsQueryKey, ...restOptions } = options;
    return {
      queryKey: optionsQueryKey ?? variables === undefined ? ['userConnection.infiniteSuspense'] : ['userConnection.infiniteSuspense', variables],
      queryFn: (metaData) => fetcher<TinaGraphql_UserConnectionQuery, TinaGraphql_UserConnectionQueryVariables>(TinaGraphql_UserConnectionDocument, {...variables, ...(metaData.pageParam ?? {})})(),
      ...restOptions
    }
  })()
    )};

useSuspenseInfiniteUserConnectionQuery.getKey = (variables?: TinaGraphql_UserConnectionQueryVariables) => variables === undefined ? ['userConnection.infiniteSuspense'] : ['userConnection.infiniteSuspense', variables];

useSuspenseInfiniteUserConnectionQuery.rootKey = 'userConnection.infinite';


useUserConnectionQuery.fetcher = (variables?: TinaGraphql_UserConnectionQueryVariables, options?: RequestInit['headers']) => fetcher<TinaGraphql_UserConnectionQuery, TinaGraphql_UserConnectionQueryVariables>(TinaGraphql_UserConnectionDocument, variables, options);
