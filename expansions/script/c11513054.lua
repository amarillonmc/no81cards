--闪术兵器 — 澪矢
local s,id,o=GetID()
function c11513054.initial_effect(c)
	--to deck 

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,11513054)
	e1:SetCondition(c11513054.opcon)
	e1:SetTarget(c11513054.optg)
	e1:SetOperation(c11513054.opop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11514054)
	e2:SetCost(c11513054.spcost)
	e2:SetTarget(c11513054.sptg)
	e2:SetOperation(c11513054.spop)
	c:RegisterEffect(e2)
	if not c11513054.global_check then
		c11513054.global_check=true
		local _IsLinkSetCard=Card.IsLinkSetCard
		function Card.IsLinkSetCard(c,setname)
			local tp=c:GetControler()
			if Duel.GetFlagEffect(tp,id)>0 and (setname==0x1115 or setname==0x115) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) then return true end
			return _IsLinkSetCard(c,setname)
		end
		function Auxiliary.LExtraFilter(c,f,lc,tp)
			if c:IsOnField() and c:IsFacedown() and not (c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetFlagEffect(tp,id)>0) then return false end
			if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
			local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
			for _,te in pairs(le) do
				local tf=te:GetValue()
				local related,valid=tf(te,lc,nil,c,tp)
				if related then return true end
			end
			return false
		end
	end
end
function c11513054.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0x1115)
end
function c11513054.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11513054.thfilter,1,nil)
end
function c11513054.tdfil(c) 
	return c:IsAbleToDeck() and c:IsFaceupEx()  
end 
function c11513054.optg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11513054.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	if chk==0 then return #g>=4 and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c11513054.opop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11513054.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c) 
	if #g>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,4,4,nil)
		sg:AddCard(c)
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end 

function c11513054.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11513054.filter(c)
	return c:IsLinkSummonable(nil)
end
function c11513054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11513054.mattg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11513054.mattg2(e,c)
	return c:GetSequence()>4
end
function c11513054.matfilter(c,e)
	local efftable=table.pack(c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL))
	if #efftable==0 then return false end
	for i,v in ipairs(efftable) do
		if v:GetLabel()~=id then return false end
	end
	return true
end
function c11513054.matval(e,lc,mg,c,tp)
	if e:GetHandlerPlayer()~=tp then return false,nil end
	return true,not mg or mg:FilterCount(c11513054.matfilter,c,e)<Duel.GetFlagEffect(tp,id)
end
function c11513054.attcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,id)>0
end
function c11513054.matfilter2(c,e)
	local efftable=table.pack(c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL))
	if #efftable==0 then return false end
	for i,v in ipairs(efftable) do
		if v:GetLabel()~=id+1 then return false end
	end
	return true
end
function c11513054.matval2(e,lc,mg,c,tp)
	if e:GetHandlerPlayer()~=tp then return false,nil end
	return true,not mg or mg:FilterCount(c11513054.matfilter2,c,e)<1
end
function c11513054.cfilter(c)
	return c:GetSequence()<5
end
function c11513054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_LINK_ATTRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(c11513054.attcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(ATTRIBUTE_DARK)
	Duel.RegisterEffect(e1,tp)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCountLimit(1)
	e2:SetLabel(id)
	e2:SetTarget(c11513054.mattg)
	e2:SetValue(c11513054.matval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local re=Effect.CreateEffect(c)
	re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	re:SetCode(EVENT_ADJUST)
	re:SetLabelObject(e2)
	re:SetOperation(c11513054.resetop)
	Duel.RegisterEffect(re,tp)
	
	--extra material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetLabel(id+1)
	e3:SetTarget(c11513054.mattg2)
	e3:SetValue(c11513054.matval2)

	if not Duel.IsExistingMatchingCard(c11513054.cfilter,tp,LOCATION_MZONE,0,1,nil) then Duel.RegisterEffect(e3,tp) end
	if Duel.GetCurrentChain()==1 then
		local sg=Duel.GetMatchingGroup(Card.IsStatus,0,LOCATION_SZONE,LOCATION_SZONE,nil,STATUS_LEAVE_CONFIRMED)
		sg:KeepAlive()
		for tc in aux.Next(sg) do
			tc:SetStatus(STATUS_LEAVE_CONFIRMED,false)
		end
		local tde=Effect.CreateEffect(c)
		tde:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		tde:SetCode(EVENT_CHAIN_END)
		tde:SetLabelObject(sg)
		tde:SetOperation(c11513054.tdop)
		Duel.RegisterEffect(tde,tp)
	end
	if Duel.IsExistingMatchingCard(c11513054.filter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)   
		local g=Duel.SelectMatchingCard(tp,c11513054.filter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local re2=Effect.CreateEffect(c)
			re2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			re2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			re2:SetCode(EVENT_MOVE)
			re2:SetLabelObject(e3)
			re2:SetOperation(c11513054.resetop2)
			tc:RegisterEffect(re2)
			Duel.LinkSummon(tp,tc,nil)
		else
			e3:Reset()
		end
	else
		e3:Reset()
	end
end
function c11513054.resetop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te or not te:CheckCountLimit(tp) then
		Duel.ResetFlagEffect(tp,id)
		e:Reset()
	end
	--
end
function c11513054.resetop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end
function c11513054.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	for tc in aux.Next(sg) do
		tc:SetStatus(STATUS_LEAVE_CONFIRMED,true)
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	e:Reset()
end




















