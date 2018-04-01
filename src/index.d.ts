type KVMap<T> = {
	[key: string]: T;
};
type StringKVMap = KVMap<string>;

type FileMetaInfo = {
	title: string;
	description: string;
	fullPath: string;
};

type FileMetaInfoMap = KVMap<FileMetaInfo>;
