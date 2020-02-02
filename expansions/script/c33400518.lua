--四糸乃 雪夜回忆
local m=33400518
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit()  
 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6341,0x3344)
end

function cm.ckfilter(c)
	return c:IsSetCard(0x3344) and c:IsFaceup()
end
function cm.thcfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thcfilter,1,nil,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.cfilter1(c)
	return c:IsType(TYPE_RITUAL)and c:IsType(TYPE_MONSTER)
end
function cm.cfilter2(c)
	return c:IsType(TYPE_FUSION)and c:IsType(TYPE_MONSTER)
end
function cm.cfilter3(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter4(c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter5(c)
	return c:IsType(TYPE_LINK)and c:IsType(TYPE_MONSTER)
end
function cm.filter2(c,tp)
	return c:IsSetCard(0x3344) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) 
end
function cm.filter3(c,e,tp)
	return c:IsSetCard(0x341) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_GRAVE) or  Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function cm.pcfilter(c)
	return  c:IsSetCard(0x341) and c:IsLevelBelow(8) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.thcfilter1(c,ec)	
		return c:IsLocation(LOCATION_MZONE)  and ec:GetLinkedGroup():IsContains(c)   
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	 local tg1=eg:Filter(cm.thcfilter,nil,e:GetHandler())
	 local tc=tg1:GetFirst() 
	 while tc do
		 if tc:IsLocation(LOCATION_MZONE)  then  
		 tc:AddCounter(0x1015,1)		  
		 end
		 tc=tg1:GetNext()
	 end
	 local op={}
	local i=0
	if eg:IsExists(cm.cfilter1,1,nil) and Duel.GetFlagEffect(tp,m+10000)==0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then 
	op[i]=0 
	i=i+1
	end
	if eg:IsExists(cm.cfilter2,1,nil) and Duel.GetFlagEffect(tp,m+20000)==0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil,tp) then 
	op[i]=1 
	i=i+1
	end
	if eg:IsExists(cm.cfilter3,1,nil) and Duel.GetFlagEffect(tp,m+30000)==0  and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	op[i]=2 
	i=i+1
	end
	if eg:IsExists(cm.cfilter4,1,nil) and Duel.GetFlagEffect(tp,m+40000)==0  and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) then 
	op[i]=3
	i=i+1
	end
	if eg:IsExists(cm.cfilter5,1,nil) and Duel.GetFlagEffect(tp,m+50000)==0 and Duel.IsPlayerCanDraw(tp,1) then 
	op[i]=4 
	i=i+1
	end 
	if i==0  then return 
	else	
		 if Duel.SelectYesNo(tp,aux.Stringid(m,5)) then   
			local j=0
			local op1
			repeat
				 if i==1 then 
				  op1=0
				 end
				 if i==2 then 
				  op1=Duel.SelectOption(tp,aux.Stringid(m,op[0]),aux.Stringid(m,op[1]))
				 end
				 if i==3 then 
				  op1=Duel.SelectOption(tp,aux.Stringid(m,op[0]),aux.Stringid(m,op[1]),aux.Stringid(m,op[2]))
				 end
				 if i==4 then 
				   op1=Duel.SelectOption(tp,aux.Stringid(m,op[0]),aux.Stringid(m,op[1]),aux.Stringid(m,op[2]),aux.Stringid(m,op[3]))
				 end
				 if i==5 then 
				   op1=Duel.SelectOption(tp,aux.Stringid(m,op[0]),aux.Stringid(m,op[1]),aux.Stringid(m,op[2]),aux.Stringid(m,op[3]),aux.Stringid(m,op[4]))
				 end
				 local xz=0
				  if op[op1]==0 then
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				  local tc3=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				  Duel.Destroy(tc3,REASON_EFFECT)	 
				  Duel.RegisterFlagEffect(tp,m+10000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					if op1~=i then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					i=i-1
					xz=1
				  end
				  if op[op1]==1 and xz==0 then 
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				  local tc3=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp)
					Duel.SSet(tp,tc3)
					Duel.RegisterFlagEffect(tp,m+20000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					if op1~=i then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					i=i-1
					xz=1
				  end
				  if op[op1]==2 and xz==0 then			  
				   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				   local  g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)			 
					if g:GetCount()>0 then
						Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
					end
					 Duel.RegisterFlagEffect(tp,m+30000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					 if op1~=i then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					 i=i-1
					 xz=1
				  end
				  if op[op1]==3 and xz==0 then 
				   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				   local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
					Duel.Destroy(g,REASON_EFFECT)
					if Duel.GetLocationCount(tp,LOCATION_PZONE)~=0 and Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_EXTRA,0,1,nil) then 
						if Duel.SelectYesNo(tp,aux.Stringid(m,7)) then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
							local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
							if g:GetCount()>0 then
								Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
							end 
						end
					end
					  Duel.RegisterFlagEffect(tp,m+40000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					 if op1~=i then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					 i=i-1
					 xz=1
				  end
				  if op[op1]==4 and xz==0 then 
					  Duel.Draw(tp,1,REASON_EFFECT)
					  Duel.ShuffleHand(tp)
					  Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
					  Duel.RegisterFlagEffect(tp,m+50000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
					  if op1~=i then 
						for i2=op1,i-1 do
						   op[op1]=op[op1+1]
						end
					end
					  i=i-1
					  xz=1
				  end
			if i==0 then j=0 
			else if Duel.SelectYesNo(tp,aux.Stringid(m,6)) then j=1
				 else  j=0
				 end
			end  
			xz=0 
			until(j==0) 
			Duel.BreakEffect()
		end
	end
end