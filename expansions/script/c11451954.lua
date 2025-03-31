--斗气传送士
local cm,m=GetID()
function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_DECK)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.sumcon)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=nil
		cm[1]=nil
		local _SelectMatchingCard=Duel.SelectMatchingCard
		local _GetMatchingGroup=Duel.GetMatchingGroup
		local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
		local _FilterSelect=Group.FilterSelect
		local _Select=Group.Select
		local _SelectSubGroup=Group.SelectSubGroup
		function Duel.GetMatchingGroup(f,p,s,o,nc,...)
			local s1=s==LOCATION_HAND and LOCATION_DECK or 0
			local o1=o==LOCATION_HAND and LOCATION_DECK or 0
			local g=_GetMatchingGroup(nil,p,s1,o1,nc,...):Filter(function(c) return c:GetOriginalCode()==m end,nil)
			if (s==LOCATION_HAND or s==0) and (o==LOCATION_HAND or o==0) and #g>0 then
				g:KeepAlive()
				local tmp0=cm[0]
				cm[0]={g,p,s1,o1,f,...}
				local sg=_GetMatchingGroup(f,p,s,o,nc,...)
				if cm[g] then cm[sg]=cm[g] end
				g:DeleteGroup()
				cm[0]=tmp0
				cm[g]=nil
				return sg
			end
			local sg=_GetMatchingGroup(f,p,s,o,nc,...)
			return sg
		end
		function Card.IsCanBeSpecialSummoned(c,e,st,sp,...)
			if aux.GetValueType(cm[0])=="table" then
				local g,p,s1,o1=table.unpack(cm[0])
				if aux.GetValueType(g)=="Group" and ((sp==p and s1~=0) or (sp~=p and s2~=0)) then
					local sg=g:Filter(_IsCanBeSpecialSummoned,nil,e,st,sp,...)
					if #sg>0 then cm[g]={{table.unpack(cm[0],2)},e,st,sp,...} end
				end
			end
			return _IsCanBeSpecialSummoned(c,e,st,sp,...)
		end
		function Duel.SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			local g=Duel.GetMatchingGroup(f,p,s,o,nc,...)
			return g:Select(sp,min,max,nc)
		end
		function Group.FilterSelect(g,sp,f,min,max,nc,...)
			if aux.GetValueType(cm[g])=="table" then
				local fg=cm.filter(g,f,nc,...)
				return fg:Select(sp,min,max,nc)
			else
				return _FilterSelect(g,sp,f,min,max,nc,...)
			end
		end
		function Group.Select(g,sp,min,max,nc)
			if aux.GetValueType(cm[g])=="table" and max>1 and sp==cm[g][4] and not Duel.IsPlayerAffectedByEffect(sp,59822133) then
				local p,s1,o1,f=table.unpack(cm[g][1])
				local tg=_GetMatchingGroup(nil,p,s1,o1,nc,table.unpack(cm[g][1],5)):Filter(function(c) return c:GetOriginalCode()==m end,nil)
				local sg=tg:Filter(_IsCanBeSpecialSummoned,nil,table.unpack(cm[g],2))
				return _SelectSubGroup(cm.filter(g+sg,nil,nc),sp,function(lg) return #(lg&sg)<=1 end,false,math.min(#g,min),max) or Group.CreateGroup()
			else
				return _Select(g,sp,min,max,nc)
			end
		end
		function Group.SelectSubGroup(g,sp,gf,cancel,min,max,...)
			if aux.GetValueType(cm[g])=="table" and sp==cm[g][4] and not Duel.IsPlayerAffectedByEffect(sp,59822133) then
				local p,s1,o1,f=table.unpack(cm[g][1])
				local tg=_GetMatchingGroup(nil,p,s1,o1,nc,table.unpack(cm[g][1],5)):Filter(function(c) return c:GetOriginalCode()==m end,nil)
				local sg=tg:Filter(_IsCanBeSpecialSummoned,nil,table.unpack(cm[g],2))
				if (max==1 and Duel.GetLocationCount(sp,LOCATION_MZONE)>1) then max=max+1 end --bug.
				return _SelectSubGroup(g+sg,sp,function(lg,...) return #(lg&sg)<=1 and gf(lg,...) end,cancel,min,max,...)
			else
				return _SelectSubGroup(g,sp,gf,cancel,min,max,...)
			end
		end
	end
	if not PNFL_DUEL_ACT_CHECK then
		PNFL_DUEL_ACT_CHECK={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,1)
		ge1:SetTarget(cm.chktg)
		ge1:SetOperation(cm.check2)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.chktg(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.check2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local code,code2=te:GetHandler():GetCode()
	table.insert(PNFL_DUEL_ACT_CHECK,code)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetLabel(Duel.GetCurrentChain()+1,#PNFL_DUEL_ACT_CHECK)
	e1:SetOperation(cm.reset2)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,0)
	if code2 then
		table.insert(PNFL_DUEL_ACT_CHECK,code2)
		local e2=e1:Clone()
		e2:SetLabel(Duel.GetCurrentChain()+1,#PNFL_DUEL_ACT_CHECK)
		Duel.RegisterEffect(e2,0)
	end
end
function cm.reset2(e,tp,eg,ep,ev,re,r,rp)
	local ev0,loc=e:GetLabel()
	if ev==ev0 then table.remove(PNFL_DUEL_ACT_CHECK,loc) end
end
function cm.filter(g,f,nc,...)
	if aux.GetValueType(f)=="function" then return g:Filter(f,nc,...) end
	local ng=g:Clone()
	if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
	if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end
	return ng
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.tsfilter(c)
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)<=0 then return false end
	for i=1,#PNFL_DUEL_ACT_CHECK do
		local code=PNFL_DUEL_ACT_CHECK[i]
		if c:IsCode(code) then return true end
	end
	return false
end
function cm.tdfilter(c)
	if not c:IsAbleToDeck() then return false end
	for i=1,#PNFL_DUEL_ACT_CHECK do
		local code=PNFL_DUEL_ACT_CHECK[i]
		if c:IsCode(code) then return true end
	end
	return false
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.tsfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local s,o=LOCATION_MZONE,0
		if tc:IsControler(1-tp) then s,o=0,LOCATION_MZONE end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,s,o,0)
		if tc:IsControler(1-tp) then fd=fd>>16 end
		local nseq=math.log(fd,2)
		Duel.MoveSequence(tc,nseq)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc2=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil):GetFirst()
		if tc2 then
			if tc2:IsExtraDeckMonster() or Duel.SelectOption(tp,aux.Stringid(81028112,1),aux.Stringid(81028112,2))==0 then
				Duel.SendtoDeck(tc2,nil,0,REASON_EFFECT)
			else
				Duel.SendtoDeck(tc2,nil,1,REASON_EFFECT)
			end
		end
	end
end