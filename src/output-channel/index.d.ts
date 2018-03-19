type OutputChannel = {

	setMiniOutput: (miniOutput: boolean) => void;
	getMiniOutput: () => boolean;

	printQueryInfo: (keywordsArray: Array<string>, fileNameLimit?: string) => void;

	printFilenameDividingLine: (fileName: string) => void;
	printMoreEllipsis: () => void;

	printCommentLine: (content: string, highlightRegexp: RegExp) => void;
	printLine: (content: string, highlightRegexp: RegExp) => void;

	finish: () => void;
};
