declare interface OutputChannel {

	setMiniOutput(miniOutput: boolean): void;
	getMiniOutput(): boolean;
	isMiniOutput(): boolean;
	
	printQueryInfo(keywordsArray: Array<string>, fileNameLimit?: string): void;
	
	printFilenameDividingLine(fileName: string): void;
	printMoreEllipsis(): void;

	printCommentLine(content: string, highlightRegexp: RegExp): void;
	printLine(content: string, highlightRegexp: RegExp): void;

	finish(): void;
}