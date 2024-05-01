/* template-start: disable-eslint */
/* eslint-disable */
/* template-end: disable-eslint */

import {
  useQuery,
  useSuspenseQuery,
  useInfiniteQuery,
  useSuspenseInfiniteQuery,
  type UseQueryOptions,
  type UseSuspenseQueryOptions,
  type UseInfiniteQueryOptions,
  type InfiniteData,
  type UseSuspenseInfiniteQueryOptions,
} from "@tanstack/react-query";
import { fetcher } from "../fetcher";

/* template-start: common-scalars */
import type { CustomScalars } from "@w3yz/types";
/* template-end: common-scalars */

export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = {
  [K in keyof T]: T[K];
};
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]?: Maybe<T[SubKey]>;
};
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]: Maybe<T[SubKey]>;
};
export type MakeEmpty<
  T extends { [key: string]: unknown },
  K extends keyof T,
> = { [_ in K]?: never };
export type Incremental<T> =
  | T
  | {
      [P in keyof T]?: P extends " $fragmentName" | "__typename" ? T[P] : never;
    };
export type FieldWrapper<T> = T;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string };
  String: { input: string; output: string };
  Boolean: { input: boolean; output: boolean };
  Int: { input: number; output: number };
  Float: { input: number; output: number };
  JSON: {
    input: CustomScalars["JSONValue"];
    output: CustomScalars["JSONValue"];
  };
  /** References another document, used as a foreign key */
  Reference: {
    input: CustomScalars["AnyObject"];
    output: CustomScalars["AnyObject"];
  };
};

export type ICollection = {
  __typename?: "Collection";
  documents: FieldWrapper<IDocumentConnection>;
  fields?: Maybe<Array<Maybe<FieldWrapper<Scalars["JSON"]["output"]>>>>;
  format?: Maybe<FieldWrapper<Scalars["String"]["output"]>>;
  label?: Maybe<FieldWrapper<Scalars["String"]["output"]>>;
  matches?: Maybe<FieldWrapper<Scalars["String"]["output"]>>;
  name: FieldWrapper<Scalars["String"]["output"]>;
  path: FieldWrapper<Scalars["String"]["output"]>;
  slug: FieldWrapper<Scalars["String"]["output"]>;
  templates?: Maybe<Array<Maybe<FieldWrapper<Scalars["JSON"]["output"]>>>>;
};

export type ICollectionDocumentsArgs = {
  after?: InputMaybe<Scalars["String"]["input"]>;
  before?: InputMaybe<Scalars["String"]["input"]>;
  filter?: InputMaybe<IDocumentFilter>;
  first?: InputMaybe<Scalars["Float"]["input"]>;
  folder?: InputMaybe<Scalars["String"]["input"]>;
  last?: InputMaybe<Scalars["Float"]["input"]>;
  sort?: InputMaybe<Scalars["String"]["input"]>;
};

/** A relay-compliant pagination connection */
export type IConnection = {
  pageInfo: FieldWrapper<IPageInfo>;
  totalCount: FieldWrapper<Scalars["Float"]["output"]>;
};

export type IDocument = {
  _sys?: Maybe<FieldWrapper<ISystemInfo>>;
  _values: FieldWrapper<Scalars["JSON"]["output"]>;
  id: FieldWrapper<Scalars["ID"]["output"]>;
};

export type IDocumentConnection = IConnection & {
  __typename?: "DocumentConnection";
  edges?: Maybe<Array<Maybe<FieldWrapper<IDocumentConnectionEdges>>>>;
  pageInfo: FieldWrapper<IPageInfo>;
  totalCount: FieldWrapper<Scalars["Float"]["output"]>;
};

export type IDocumentConnectionEdges = {
  __typename?: "DocumentConnectionEdges";
  cursor: FieldWrapper<Scalars["String"]["output"]>;
  node?: Maybe<FieldWrapper<IDocumentNode>>;
};

export type IDocumentFilter = {
  user?: InputMaybe<IUserFilter>;
};

export type IDocumentMutation = {
  user?: InputMaybe<IUserMutation>;
};

export type IDocumentNode = IFolder | IUser;

export type IDocumentUpdateMutation = {
  relativePath?: InputMaybe<Scalars["String"]["input"]>;
  user?: InputMaybe<IUserMutation>;
};

export type IFolder = {
  __typename?: "Folder";
  name: FieldWrapper<Scalars["String"]["output"]>;
  path: FieldWrapper<Scalars["String"]["output"]>;
};

export type IMutation = {
  __typename?: "Mutation";
  addPendingDocument: FieldWrapper<IDocumentNode>;
  createDocument: FieldWrapper<IDocumentNode>;
  createUser: FieldWrapper<IUser>;
  deleteDocument: FieldWrapper<IDocumentNode>;
  updateDocument: FieldWrapper<IDocumentNode>;
  updatePassword: FieldWrapper<Scalars["Boolean"]["output"]>;
  updateUser: FieldWrapper<IUser>;
};

export type IMutationAddPendingDocumentArgs = {
  collection: Scalars["String"]["input"];
  relativePath: Scalars["String"]["input"];
  template?: InputMaybe<Scalars["String"]["input"]>;
};

export type IMutationCreateDocumentArgs = {
  collection?: InputMaybe<Scalars["String"]["input"]>;
  params: IDocumentMutation;
  relativePath: Scalars["String"]["input"];
};

export type IMutationCreateUserArgs = {
  params: IUserMutation;
  relativePath: Scalars["String"]["input"];
};

export type IMutationDeleteDocumentArgs = {
  collection?: InputMaybe<Scalars["String"]["input"]>;
  relativePath: Scalars["String"]["input"];
};

export type IMutationUpdateDocumentArgs = {
  collection?: InputMaybe<Scalars["String"]["input"]>;
  params: IDocumentUpdateMutation;
  relativePath: Scalars["String"]["input"];
};

export type IMutationUpdatePasswordArgs = {
  password: Scalars["String"]["input"];
};

export type IMutationUpdateUserArgs = {
  params: IUserMutation;
  relativePath: Scalars["String"]["input"];
};

export type INode = {
  id: FieldWrapper<Scalars["ID"]["output"]>;
};

export type IPageInfo = {
  __typename?: "PageInfo";
  endCursor: FieldWrapper<Scalars["String"]["output"]>;
  hasNextPage: FieldWrapper<Scalars["Boolean"]["output"]>;
  hasPreviousPage: FieldWrapper<Scalars["Boolean"]["output"]>;
  startCursor: FieldWrapper<Scalars["String"]["output"]>;
};

export type IQuery = {
  __typename?: "Query";
  authenticate?: Maybe<FieldWrapper<IUserUsers>>;
  authorize?: Maybe<FieldWrapper<IUserUsers>>;
  collection: FieldWrapper<ICollection>;
  collections: Array<FieldWrapper<ICollection>>;
  document: FieldWrapper<IDocumentNode>;
  getOptimizedQuery?: Maybe<FieldWrapper<Scalars["String"]["output"]>>;
  node: FieldWrapper<INode>;
  user: FieldWrapper<IUser>;
  userConnection: FieldWrapper<IUserConnection>;
};

export type IQueryAuthenticateArgs = {
  password: Scalars["String"]["input"];
  sub: Scalars["String"]["input"];
};

export type IQueryCollectionArgs = {
  collection?: InputMaybe<Scalars["String"]["input"]>;
};

export type IQueryDocumentArgs = {
  collection?: InputMaybe<Scalars["String"]["input"]>;
  relativePath?: InputMaybe<Scalars["String"]["input"]>;
};

export type IQueryGetOptimizedQueryArgs = {
  queryString: Scalars["String"]["input"];
};

export type IQueryNodeArgs = {
  id?: InputMaybe<Scalars["String"]["input"]>;
};

export type IQueryUserArgs = {
  relativePath?: InputMaybe<Scalars["String"]["input"]>;
};

export type IQueryUserConnectionArgs = {
  after?: InputMaybe<Scalars["String"]["input"]>;
  before?: InputMaybe<Scalars["String"]["input"]>;
  filter?: InputMaybe<IUserFilter>;
  first?: InputMaybe<Scalars["Float"]["input"]>;
  last?: InputMaybe<Scalars["Float"]["input"]>;
  sort?: InputMaybe<Scalars["String"]["input"]>;
};

export type IStringFilter = {
  eq?: InputMaybe<Scalars["String"]["input"]>;
  exists?: InputMaybe<Scalars["Boolean"]["input"]>;
  in?: InputMaybe<Array<InputMaybe<Scalars["String"]["input"]>>>;
  startsWith?: InputMaybe<Scalars["String"]["input"]>;
};

export type ISystemInfo = {
  __typename?: "SystemInfo";
  basename: FieldWrapper<Scalars["String"]["output"]>;
  breadcrumbs: Array<FieldWrapper<Scalars["String"]["output"]>>;
  collection: FieldWrapper<ICollection>;
  extension: FieldWrapper<Scalars["String"]["output"]>;
  filename: FieldWrapper<Scalars["String"]["output"]>;
  path: FieldWrapper<Scalars["String"]["output"]>;
  relativePath: FieldWrapper<Scalars["String"]["output"]>;
  template: FieldWrapper<Scalars["String"]["output"]>;
  title?: Maybe<FieldWrapper<Scalars["String"]["output"]>>;
};

export type ISystemInfoBreadcrumbsArgs = {
  excludeExtension?: InputMaybe<Scalars["Boolean"]["input"]>;
};

export type IUser = IDocument &
  INode & {
    __typename?: "User";
    _sys: FieldWrapper<ISystemInfo>;
    _values: FieldWrapper<Scalars["JSON"]["output"]>;
    id: FieldWrapper<Scalars["ID"]["output"]>;
    users?: Maybe<Array<Maybe<FieldWrapper<IUserUsers>>>>;
  };

export type IUserConnection = IConnection & {
  __typename?: "UserConnection";
  edges?: Maybe<Array<Maybe<FieldWrapper<IUserConnectionEdges>>>>;
  pageInfo: FieldWrapper<IPageInfo>;
  totalCount: FieldWrapper<Scalars["Float"]["output"]>;
};

export type IUserConnectionEdges = {
  __typename?: "UserConnectionEdges";
  cursor: FieldWrapper<Scalars["String"]["output"]>;
  node?: Maybe<FieldWrapper<IUser>>;
};

export type IUserFilter = {
  users?: InputMaybe<IUserUsersFilter>;
};

export type IUserMutation = {
  users?: InputMaybe<Array<InputMaybe<IUserUsersMutation>>>;
};

export type IUserUsers = {
  __typename?: "UserUsers";
  email?: Maybe<FieldWrapper<Scalars["String"]["output"]>>;
  name?: Maybe<FieldWrapper<Scalars["String"]["output"]>>;
  password: FieldWrapper<IUserUsersPassword>;
  username: FieldWrapper<Scalars["String"]["output"]>;
};

export type IUserUsersFilter = {
  email?: InputMaybe<IStringFilter>;
  name?: InputMaybe<IStringFilter>;
  username?: InputMaybe<IStringFilter>;
};

export type IUserUsersMutation = {
  email?: InputMaybe<Scalars["String"]["input"]>;
  name?: InputMaybe<Scalars["String"]["input"]>;
  password?: InputMaybe<IUserUsersPasswordMutation>;
  username?: InputMaybe<Scalars["String"]["input"]>;
};

export type IUserUsersPassword = {
  __typename?: "UserUsersPassword";
  passwordChangeRequired?: Maybe<FieldWrapper<Scalars["Boolean"]["output"]>>;
  value: FieldWrapper<Scalars["String"]["output"]>;
};

export type IUserUsersPasswordMutation = {
  passwordChangeRequired: Scalars["Boolean"]["input"];
  value?: InputMaybe<Scalars["String"]["input"]>;
};

export type IUserPartsFragment = {
  __typename: "User";
  users?: Array<{
    __typename: "UserUsers";
    username: string;
    name?: string | null;
    email?: string | null;
    password: {
      __typename?: "UserUsersPassword";
      value: string;
      passwordChangeRequired?: boolean | null;
    };
  } | null> | null;
};

export type IUserQueryVariables = Exact<{
  relativePath: Scalars["String"]["input"];
}>;

export type IUserQuery = {
  user: {
    __typename: "User";
    id: string;
    _sys: {
      __typename?: "SystemInfo";
      filename: string;
      basename: string;
      breadcrumbs: Array<string>;
      path: string;
      relativePath: string;
      extension: string;
    };
    users?: Array<{
      __typename: "UserUsers";
      username: string;
      name?: string | null;
      email?: string | null;
      password: {
        __typename?: "UserUsersPassword";
        value: string;
        passwordChangeRequired?: boolean | null;
      };
    } | null> | null;
  };
};

export type IUserConnectionQueryVariables = Exact<{
  before?: InputMaybe<Scalars["String"]["input"]>;
  after?: InputMaybe<Scalars["String"]["input"]>;
  first?: InputMaybe<Scalars["Float"]["input"]>;
  last?: InputMaybe<Scalars["Float"]["input"]>;
  sort?: InputMaybe<Scalars["String"]["input"]>;
  filter?: InputMaybe<IUserFilter>;
}>;

export type IUserConnectionQuery = {
  userConnection: {
    __typename?: "UserConnection";
    totalCount: number;
    pageInfo: {
      __typename?: "PageInfo";
      hasPreviousPage: boolean;
      hasNextPage: boolean;
      startCursor: string;
      endCursor: string;
    };
    edges?: Array<{
      __typename?: "UserConnectionEdges";
      cursor: string;
      node?: {
        __typename: "User";
        id: string;
        _sys: {
          __typename?: "SystemInfo";
          filename: string;
          basename: string;
          breadcrumbs: Array<string>;
          path: string;
          relativePath: string;
          extension: string;
        };
        users?: Array<{
          __typename: "UserUsers";
          username: string;
          name?: string | null;
          email?: string | null;
          password: {
            __typename?: "UserUsersPassword";
            value: string;
            passwordChangeRequired?: boolean | null;
          };
        } | null> | null;
      } | null;
    } | null> | null;
  };
};

export const UserPartsFragmentDoc = `
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
export const UserDocument = `
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
    ${UserPartsFragmentDoc}`;

export const useUserQuery = <TData = IUserQuery, TError = unknown>(
  variables: IUserQueryVariables,
  options?: Omit<UseQueryOptions<IUserQuery, TError, TData>, "queryKey"> & {
    queryKey?: UseQueryOptions<IUserQuery, TError, TData>["queryKey"];
  }
) => {
  return useQuery<IUserQuery, TError, TData>({
    queryKey: ["user", variables],
    queryFn: fetcher<IUserQuery, IUserQueryVariables>(UserDocument, variables),
    ...options,
  });
};

useUserQuery.document = UserDocument;

useUserQuery.getKey = (variables: IUserQueryVariables) => ["user", variables];

useUserQuery.rootKey = "user";

export const useSuspenseUserQuery = <TData = IUserQuery, TError = unknown>(
  variables: IUserQueryVariables,
  options?: Omit<
    UseSuspenseQueryOptions<IUserQuery, TError, TData>,
    "queryKey"
  > & {
    queryKey?: UseSuspenseQueryOptions<IUserQuery, TError, TData>["queryKey"];
  }
) => {
  return useSuspenseQuery<IUserQuery, TError, TData>({
    queryKey: ["userSuspense", variables],
    queryFn: fetcher<IUserQuery, IUserQueryVariables>(UserDocument, variables),
    ...options,
  });
};

useSuspenseUserQuery.document = UserDocument;

useSuspenseUserQuery.getKey = (variables: IUserQueryVariables) => [
  "userSuspense",
  variables,
];

useSuspenseUserQuery.rootKey = "user";

export const useInfiniteUserQuery = <
  TData = InfiniteData<IUserQuery>,
  TError = unknown,
>(
  variables: IUserQueryVariables,
  options: Omit<
    UseInfiniteQueryOptions<IUserQuery, TError, TData>,
    "queryKey"
  > & {
    queryKey?: UseInfiniteQueryOptions<IUserQuery, TError, TData>["queryKey"];
  }
) => {
  return useInfiniteQuery<IUserQuery, TError, TData>(
    (() => {
      const { queryKey: optionsQueryKey, ...restOptions } = options;
      return {
        queryKey: optionsQueryKey ?? ["user.infinite", variables],
        queryFn: (metaData) =>
          fetcher<IUserQuery, IUserQueryVariables>(UserDocument, {
            ...variables,
            ...(metaData.pageParam ?? {}),
          })(),
        ...restOptions,
      };
    })()
  );
};

useInfiniteUserQuery.getKey = (variables: IUserQueryVariables) => [
  "user.infinite",
  variables,
];

useInfiniteUserQuery.rootKey = "user.infinite";

export const useSuspenseInfiniteUserQuery = <
  TData = InfiniteData<IUserQuery>,
  TError = unknown,
>(
  variables: IUserQueryVariables,
  options: Omit<
    UseSuspenseInfiniteQueryOptions<IUserQuery, TError, TData>,
    "queryKey"
  > & {
    queryKey?: UseSuspenseInfiniteQueryOptions<
      IUserQuery,
      TError,
      TData
    >["queryKey"];
  }
) => {
  return useSuspenseInfiniteQuery<IUserQuery, TError, TData>(
    (() => {
      const { queryKey: optionsQueryKey, ...restOptions } = options;
      return {
        queryKey: optionsQueryKey ?? ["user.infiniteSuspense", variables],
        queryFn: (metaData) =>
          fetcher<IUserQuery, IUserQueryVariables>(UserDocument, {
            ...variables,
            ...(metaData.pageParam ?? {}),
          })(),
        ...restOptions,
      };
    })()
  );
};

useSuspenseInfiniteUserQuery.getKey = (variables: IUserQueryVariables) => [
  "user.infiniteSuspense",
  variables,
];

useSuspenseInfiniteUserQuery.rootKey = "user.infinite";

useUserQuery.fetcher = (
  variables: IUserQueryVariables,
  options?: RequestInit["headers"]
) => fetcher<IUserQuery, IUserQueryVariables>(UserDocument, variables, options);

export const UserConnectionDocument = `
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
    ${UserPartsFragmentDoc}`;

export const useUserConnectionQuery = <
  TData = IUserConnectionQuery,
  TError = unknown,
>(
  variables?: IUserConnectionQueryVariables,
  options?: Omit<
    UseQueryOptions<IUserConnectionQuery, TError, TData>,
    "queryKey"
  > & {
    queryKey?: UseQueryOptions<IUserConnectionQuery, TError, TData>["queryKey"];
  }
) => {
  return useQuery<IUserConnectionQuery, TError, TData>({
    queryKey:
      variables === undefined
        ? ["userConnection"]
        : ["userConnection", variables],
    queryFn: fetcher<IUserConnectionQuery, IUserConnectionQueryVariables>(
      UserConnectionDocument,
      variables
    ),
    ...options,
  });
};

useUserConnectionQuery.document = UserConnectionDocument;

useUserConnectionQuery.getKey = (variables?: IUserConnectionQueryVariables) =>
  variables === undefined ? ["userConnection"] : ["userConnection", variables];

useUserConnectionQuery.rootKey = "userConnection";

export const useSuspenseUserConnectionQuery = <
  TData = IUserConnectionQuery,
  TError = unknown,
>(
  variables?: IUserConnectionQueryVariables,
  options?: Omit<
    UseSuspenseQueryOptions<IUserConnectionQuery, TError, TData>,
    "queryKey"
  > & {
    queryKey?: UseSuspenseQueryOptions<
      IUserConnectionQuery,
      TError,
      TData
    >["queryKey"];
  }
) => {
  return useSuspenseQuery<IUserConnectionQuery, TError, TData>({
    queryKey:
      variables === undefined
        ? ["userConnectionSuspense"]
        : ["userConnectionSuspense", variables],
    queryFn: fetcher<IUserConnectionQuery, IUserConnectionQueryVariables>(
      UserConnectionDocument,
      variables
    ),
    ...options,
  });
};

useSuspenseUserConnectionQuery.document = UserConnectionDocument;

useSuspenseUserConnectionQuery.getKey = (
  variables?: IUserConnectionQueryVariables
) =>
  variables === undefined
    ? ["userConnectionSuspense"]
    : ["userConnectionSuspense", variables];

useSuspenseUserConnectionQuery.rootKey = "userConnection";

export const useInfiniteUserConnectionQuery = <
  TData = InfiniteData<IUserConnectionQuery>,
  TError = unknown,
>(
  variables: IUserConnectionQueryVariables,
  options: Omit<
    UseInfiniteQueryOptions<IUserConnectionQuery, TError, TData>,
    "queryKey"
  > & {
    queryKey?: UseInfiniteQueryOptions<
      IUserConnectionQuery,
      TError,
      TData
    >["queryKey"];
  }
) => {
  return useInfiniteQuery<IUserConnectionQuery, TError, TData>(
    (() => {
      const { queryKey: optionsQueryKey, ...restOptions } = options;
      return {
        queryKey:
          optionsQueryKey ?? variables === undefined
            ? ["userConnection.infinite"]
            : ["userConnection.infinite", variables],
        queryFn: (metaData) =>
          fetcher<IUserConnectionQuery, IUserConnectionQueryVariables>(
            UserConnectionDocument,
            { ...variables, ...(metaData.pageParam ?? {}) }
          )(),
        ...restOptions,
      };
    })()
  );
};

useInfiniteUserConnectionQuery.getKey = (
  variables?: IUserConnectionQueryVariables
) =>
  variables === undefined
    ? ["userConnection.infinite"]
    : ["userConnection.infinite", variables];

useInfiniteUserConnectionQuery.rootKey = "userConnection.infinite";

export const useSuspenseInfiniteUserConnectionQuery = <
  TData = InfiniteData<IUserConnectionQuery>,
  TError = unknown,
>(
  variables: IUserConnectionQueryVariables,
  options: Omit<
    UseSuspenseInfiniteQueryOptions<IUserConnectionQuery, TError, TData>,
    "queryKey"
  > & {
    queryKey?: UseSuspenseInfiniteQueryOptions<
      IUserConnectionQuery,
      TError,
      TData
    >["queryKey"];
  }
) => {
  return useSuspenseInfiniteQuery<IUserConnectionQuery, TError, TData>(
    (() => {
      const { queryKey: optionsQueryKey, ...restOptions } = options;
      return {
        queryKey:
          optionsQueryKey ?? variables === undefined
            ? ["userConnection.infiniteSuspense"]
            : ["userConnection.infiniteSuspense", variables],
        queryFn: (metaData) =>
          fetcher<IUserConnectionQuery, IUserConnectionQueryVariables>(
            UserConnectionDocument,
            { ...variables, ...(metaData.pageParam ?? {}) }
          )(),
        ...restOptions,
      };
    })()
  );
};

useSuspenseInfiniteUserConnectionQuery.getKey = (
  variables?: IUserConnectionQueryVariables
) =>
  variables === undefined
    ? ["userConnection.infiniteSuspense"]
    : ["userConnection.infiniteSuspense", variables];

useSuspenseInfiniteUserConnectionQuery.rootKey = "userConnection.infinite";

useUserConnectionQuery.fetcher = (
  variables?: IUserConnectionQueryVariables,
  options?: RequestInit["headers"]
) =>
  fetcher<IUserConnectionQuery, IUserConnectionQueryVariables>(
    UserConnectionDocument,
    variables,
    options
  );
