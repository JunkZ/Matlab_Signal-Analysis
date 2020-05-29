function pzlab(in1,in2)
%
% PZlab is a complete hack written by James P. LeBlanc (leblanc@sm.luth.se)
% it gives some experience with pole/zero locations, associated frequency
% repsonses and impulse responses
%
% Running PZlab:
%
%     To start PZlab with no poles or zeros initialized,
%     simply type into Matlab command line:
%
%                pzlab
%   
%     To start PZlab with poles and zeros values initialized,
%     simply type:
%   
%                pzlab(p,z)
%
%     where p = vector of pole locations
%           z = vector of zero locations
%   
% Getting output from PZlab:
%
%     PZlab automatically save the pole and zero location vectors
%     in the file name "PZoutput" upon exiting.  To access these
%     values, type:
%
%                load PZoutput
%   
%   

AXLIM=1.6;

if(nargin==0),
  info.p=[];
  info.z=[];
  action='initialize';
end

if(nargin==1),
  action=in1;
end

if(nargin==2),
  info.p=in1;
  info.z=in2;
  if( any(abs(info.p)>1)),
    error(' PZlab: INPUT ERROR specified poles lies outside unit circle! ')
  end
  if( any(real(info.z)>AXLIM) | any(imag(info.z)>AXLIM) ),
    error(' PZlab: INPUT ERROR specified zeros lies outside plot axis limites! ')
  end
  action='initialize';
end



switch action
  
 case('initialize')
  
  info.tolerance = 0.05;
  info.lag = 25;
  info.dotted = 0;
  info.fcol = [0.0 0.0 0.0];
  info.bcol = [0.7 0.7 0.7];
  info.actfcol = [0.8 0.8 0.8];
  info.actbcol = [0.3 0.3 0.3];
  info.warncol = [1.0 0.0 0.0];
  info.nextcol = [0.1 0.5 0.1];
  info.buttonsize = [170 25];
   % Open Figure -------------------------------------------------------
%  fig = figure('Color',[0.8 0.8 0.8],'Position',[300 155 709 552], ...
%               'Units','pixels', 'CloseRequestFcn','pzlab(''exitpzlab'')', ...            
%               'Resize','off', 'Menubar','none',
%               'ToolBar','none');

  fig = figure('Color',[0.8 0.8 0.8],'Position',[300 155 709 552], ...
               'Units','pixels', 'CloseRequestFcn','pzlab(''exitpzlab'')', ...            
               'Resize','off');
  
  set(fig,'UserData',info,'HandleVisibility','on');
  info.h_complex = axes('Parent',fig,'Units','pixels','Color',[0 0 0], ...
                        'XTick',[],'YTick',[],'Position',[26 202 348 323]);
  
  info.h_freq = axes('Parent',fig,'Units','pixels','Color',[1 1 1], ...
                     'Position',[24 40 325 125]);

  info.h_imp = axes('Parent',fig, 'Units','pixels', 'Color',[1 1 1], ...
                    'Position',[375 40 325 125]);
  
  info.b_addzeros = create_button([430 480 170 25],'Add Zeros','addzeros');
  info.b_addpoles = create_button([430 440 170 25],'Add Poles','addpoles');
  info.b_move = create_button([430 400 170 25],'Move Singularities','move');
  info.b_delete = create_button([430 360 170 25],'Delete Singularies','delete');
  info.b_clear = create_button([430 320 170 25],'Clear All','clearall');
  info.b_exitpzlab = create_button([430 240 170 25],'Exit PZlab','exitpzlab');
  set(fig,'UserData',info,'HandleVisibility','on');
  pzlab('redraw')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case('addzeros')
  fig = gcf;
  info = get(fig,'UserData');
  set(info.b_addzeros,'ForegroundColor',info.actfcol,'BackgroundColor',info.actbcol);
      
  axes(info.h_complex);
  xlim = get(gca,'XLim');
  ylim = get(gca,'YLim');

  
  getnext = 1;
  while(getnext),
    [x,y]=ginput(1);
    if( (xlim(1)<x) &  (x<xlim(2)) &  (ylim(1)<y) &  (y<ylim(2)) ),
    % get next zero location

    if( abs(y) > info.tolerance ),
      newz = [ x+i*y x-i*y];
    else 
      newz = [ x];
    end
    info.z = [info.z newz];
    set(fig,'UserData',info);
    pzlab('redraw')

    else
    % clicked outside of axis area
    getnext=0;
    set(info.b_addzeros,'ForegroundColor',info.fcol,'BackgroundColor',info.bcol);
    end
  end


  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case('addpoles')
  
  fig = gcf;
  info = get(fig,'UserData');
  set(info.b_addpoles,'ForegroundColor',info.actfcol,'BackgroundColor',info.actbcol);
  axes(info.h_complex);
  xlim = get(gca,'XLim');
  ylim = get(gca,'YLim');
 
  getnext = 1;
  while(getnext),
    [x,y]=ginput(1);
    if( (xlim(1)<x) &  (x<xlim(2)) &  (ylim(1)<y) &  (y<ylim(2)) ),
    % get next pole location
      set(info.b_addpoles,'ForegroundColor',info.actfcol,'BackgroundColor',info.actbcol);
      set(info.b_addpoles, 'String','Add Poles')
      if( abs(y) > info.tolerance ),
        newp = [ x+i*y x-i*y];
      else 
        newp = [ x];
      end
      if(max(abs(newp))>1)
	for iii=1:10,
          set(info.b_addpoles, 'ForegroundColor',info.actfcol,...
	      'BackgroundColor',info.actbcol,...
              'String','Must be INSIDE Unit Circle');
	  pause(0.15)
          set(info.b_addpoles, 'ForegroundColor',info.fcol,...
	      'BackgroundColor',info.warncol,...
              'String','Must be INSIDE Unit Circle');
	  pause(0.15)
	end
       else
         info.p=[info.p newp];
         set(fig,'UserData',info);
         pzlab('redraw')
       end
  else
    % clicked outside of axis area
      getnext=0;
      set(info.b_addpoles,'ForegroundColor',info.fcol,'BackgroundColor',info.bcol);
      set(info.b_addpoles, 'String','Add Poles');
    end
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case('move')
  
  fig = gcf;
  info = get(fig,'UserData');
  set(info.b_move,'ForegroundColor',info.actfcol,'BackgroundColor',info.actbcol);
  axes(info.h_complex);
  xlim = get(gca,'XLim');
  ylim = get(gca,'YLim');

  getnext = 1;
  while(getnext),  
    [x,y]=ginput(1);
    if( (xlim(1)<x) &  (x<xlim(2)) &  (ylim(1)<y) &  (y<ylim(2)) ), 
      clickpt = x+sqrt(-1)*y;
      [dp,ip] = min(abs(clickpt-info.p));
      if( isempty(dp) ),
         dp = 9999;
      end
      [dz,iz] = min(abs(clickpt-info.z));
      if( isempty(dz) ),
         dz = 9999;
      end
      distance=min(dp,dz);
      
      info.p_old = info.p;
      info.z_old = info.z;

      if(distance<info.tolerance),  
        if(dp<dz),                                 % moving pole
          if( imag(info.p(ip)) ~= 0) 
            [junk,iconj] = min(abs(conj(info.p(ip))-info.p));
            info.p([ip iconj])=[];
          else
            info.p([ip])=[];
          end  

	  info.dotted=1;
          set(fig,'UserData',info);
          pzlab('redraw')
	  info.dotted=0;

          getputlocation=1;
          set(info.b_move, 'ForegroundColor',info.actfcol,...
             'BackgroundColor',info.nextcol,...
             'String','Select New Location');

	  while(getputlocation),
            [x,y]=ginput(1);
            if( abs(y) > info.tolerance ),
              newp = [ x+sqrt(-1)*y x-sqrt(-1)*y];
            else 
              newp = [ x];
            end
            if(max(abs(newp))>1)
              for iii=1:6,
                set(info.b_move, 'ForegroundColor',info.actfcol,...
 	        'BackgroundColor',info.actbcol,...
                'String','Must be INSIDE Unit Circle');
	        pause(0.15)
                set(info.b_move, 'ForegroundColor',info.fcol,...
	        'BackgroundColor',info.warncol,...
                'String','Must be INSIDE Unit Circle');
	        pause(0.15)
  	      end
	    else
	      getputlocation=0;
           info.p=[info.p newp];
           set(fig,'UserData',info);
           set(info.b_move,'ForegroundColor',info.actfcol,'BackgroundColor',info.actbcol);
           set(info.b_move,'String','Move Singularity');
	   
           pzlab('redraw')
          end
          end

        else                                       % move zero
          if( imag(info.z(iz)) ~= 0) 
            [junk,iconj] = min(abs(conj(info.z(iz))-info.z));
            info.z([iz iconj])=[];
          else
            info.z([iz])=[];
          end 
	  
	  info.dotted=1;
          set(fig,'UserData',info);
          pzlab('redraw')
	  info.dotted=0;

          getputlocation=1;
          set(info.b_move, 'ForegroundColor',info.actfcol,...
             'BackgroundColor',info.nextcol,...
             'String','Select New Location');

	  while(getputlocation),
            [x,y]=ginput(1);
	    
            if( abs(y) > info.tolerance ),
              newz = [ x+sqrt(-1)*y x-sqrt(-1)*y];
            else 
              newz = [ x];
            end
            
            if( (xlim(1)<x) &  (x<xlim(2)) &  (ylim(1)<y) &  (y<ylim(2)) ), 
  	      getputlocation=0;
              info.z=[info.z newz];
              set(fig,'UserData',info);
              set(info.b_move,'ForegroundColor',info.actfcol,'BackgroundColor',info.actbcol);
              set(info.b_move,'String','Move Singularity');
              pzlab('redraw')
	    end
          end
        end 

      set(fig,'UserData',info);
      pzlab('redraw')
      end  
    else  
    % clicked outside of axis area
      set(info.b_move,'ForegroundColor',info.fcol,'BackgroundColor',info.bcol);
      getnext=0;
  end 
  end  

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case('delete')
  
  fig = gcf;
  info = get(fig,'UserData');
  set(info.b_delete,'ForegroundColor',info.actfcol,'BackgroundColor',info.actbcol);
  axes(info.h_complex);
  xlim = get(gca,'XLim');
  ylim = get(gca,'YLim');

  getnext = 1;
  while(getnext),  
    [x,y]=ginput(1);
    if( (xlim(1)<x) &  (x<xlim(2)) &  (ylim(1)<y) &  (y<ylim(2)) ), 
      clickpt = x+sqrt(-1)*y;
      [dp,ip] = min(abs(clickpt-info.p));
      if( isempty(dp) ),
         dp = 9999;
      end
      [dz,iz] = min(abs(clickpt-info.z));
      if( isempty(dz) ),
         dz = 9999;
      end
      distance=min(dp,dz);

      if(distance<info.tolerance),  
        if(dp<dz),                                 % deleting pole
          info.delete='pole';
          if( imag(info.p(ip)) ~= 0) 
            [junk,iconj] = min(abs(conj(info.p(ip))-info.p));
            info.p([ip iconj])=[];
          else
            info.p([ip])=[];
          end  
        else                                       % deleting zero
          info.delete='zero';
          if( imag(info.z(iz)) ~= 0) 
            [junk,iconj] = min(abs(conj(info.z(iz))-info.z));
            info.z([iz iconj])=[];
          else
            info.z([iz])=[];
          end 
        end 

      set(fig,'UserData',info);
      pzlab('redraw')
      end  
    else  
    % clicked outside of axis area
      getnext=0;
    set(info.b_delete,'ForegroundColor',info.fcol,'BackgroundColor',info.bcol);
  end 
  end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case('clearall') 
  fig = gcf;
  info = get(fig,'UserData');
  set(info.b_clear,'ForegroundColor',info.fcol,'BackgroundColor',info.bcol);
  info.p=[];
  info.z=[];
  set(fig,'UserData',info);
  pzlab('redraw')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case('redraw')
 
  fig = gcf;
  info = get(fig,'UserData');
  axes(info.h_complex)
  unitcircle = exp(sqrt(-1)*[0:0.01:1]*2*pi);
  plot(unitcircle,'r')
  hold on
  plot(AXLIM*[-1 1],[0 0],'r')
  plot([0 0], AXLIM*[-1 1],'r')
  plot(real(info.p),imag(info.p),'Marker','x','MarkerEdgeColor','cyan','LineStyle','none');
  plot(real(info.z),imag(info.z),'Marker','o','MarkerEdgeColor','green','LineStyle','none');
  axis(AXLIM*[-1 1 -1 1])
  titlestring = [' Complex Plane:  # poles= ' int2str(length(info.p)) ...
		 ',  # zeros= ' int2str(length(info.z))];
  title(titlestring)

  set(info.h_complex,'XTick',[-AXLIM:0.2:AXLIM],'YTick',[-AXLIM:0.2:AXLIM]);
  set(info.h_complex,'Color',[0 0 0])
  set(info.h_complex,'XGrid','on','XColor',[.6 .3 .3],'XTickLabel',[])
  set(info.h_complex,'YGrid','on','YColor',[.6 .3 .3],'YTickLabel',[])
  hold off

 % Draw Normalized Freq Response -------------------------
  axes(info.h_freq) 
  
  if(info.dotted),
    b = real(poly(info.z_old));
    a = real(poly(info.p_old));
  else
    b = real(poly(info.z));
    a = real(poly(info.p));
  end
  
  [H,w] = freqz(b,a,512);
  H = abs(H);
  H = H/max(H);

  axes(info.h_freq)
  if(info.dotted),
    plot(w, 20*log10(H),':')
  else
    plot(w, 20*log10(H))
  end
  
  presentaxis = axis;
  axis([0 pi presentaxis(3) 1])
  set(info.h_freq,'XTick',[0 pi/4 pi/2 3*pi/4 pi])
  set(info.h_freq,'XTickLabel',...
	 ['  0  ';' pi/4';' pi/2';'3pi/4';'  pi '])
  xlabel('Normalized Frequency')
  title('Magnitude Freq. Resp. (dB)')

  % Draw Normalized Impulse Response -------------------------
  axes(info.h_imp)
  
  poleexcess = length(info.p) - length(info.z);
  maxlag = info.lag + abs(poleexcess);

  n = [-maxlag:1:maxlag];  
  x = zeros(length(n),1);
  
  x(maxlag+1+poleexcess)=1;
  
  imp = filter(b,a,x);
  imp = imp/max(abs(imp));
  axes(info.h_imp)
  plot([-maxlag-2 maxlag+2],[0 0],'r')
  hold on
  plot([0 0], [-1.2 1.2],'r')
  hstem=stem(n,imp);
  set(hstem(1),'MarkerFaceColor',[0 0 1])
  hold off
  axis([ -maxlag-1 maxlag+1 -1.2 1.2])
  xlabel(' n ')
  title(['Impulse Resp h(n)       for ' ...
	 int2str(-maxlag) ' <= n <= ' int2str(maxlag)])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 case('exitpzlab')
  fig = gcf;
  info = get(fig,'UserData');
  
  pz_poles = info.p;
  pz_zeros = info.z;
  
  save PZoutput pz_poles pz_zeros

  set(info.b_exitpzlab,'ForegroundColor',info.fcol,'BackgroundColor',info.bcol);
  answer = questdlg('Really close PZlab?','','Yes','No','No');
  if strcmp(answer,'Yes')
  set(info.b_exitpzlab,'ForegroundColor',[0.0 0.0 0.0],'BackgroundColor',[0.7 0.7 0.7]);
  delete(gcf)

  disp(' ');
  disp(' Exited PZlab  ');
  disp(' ');
  disp(' PZlab sessions poles and zeros save in file ''PZoutput'' ');
  disp(' ');
  disp(' Hit RETURN to continue ')
  disp(' ');

  
  end
  
end

  
function hhh=create_button(POS,STRING,ACTION)
fig = gcf;
info = get(fig,'UserData');
hhh= uicontrol('Style','pushbutton', 'Position',POS, 'String',STRING,...
	       'ForegroundColor',info.fcol,'BackgroundColor',info.bcol,...
                'CallBack',['pzlab(''' ACTION ''')']);


