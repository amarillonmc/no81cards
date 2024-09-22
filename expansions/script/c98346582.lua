--龙的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c98346582.synchorfilter,aux.NonTuner(c98346582.synchorfilter),1)
	c:EnableReviveLimit()
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98346582.regcon)
	e1:SetOperation(c98346582.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c98346582.splimit)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98346582,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id)
	e3:SetCondition(c98346582.thcon)
	e3:SetTarget(c98346582.thtg)
	e3:SetOperation(c98346582.thop)
	c:RegisterEffect(e3)
	--hades
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98346582,1))
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+o)
	e4:SetHintTiming(0,TIMING_TOHAND+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e4:SetCondition(c98346582.hdcon)
	e4:SetTarget(c98346582.hdtg)
	e4:SetOperation(c98346582.hdop)
	c:RegisterEffect(e4)
	if not c98346582.global_check then
		c98346582.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c98346582.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98346582.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsSetCard(0xaf7) then
			if tc:IsSummonPlayer(0) then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,98346582,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,98346582,RESET_PHASE+PHASE_END,0,1) end
end
function c98346582.synchorfilter(c)
	return Duel.GetFlagEffect(c:GetControler(),98346582)==0 and c:IsSetCard(0xaf7)
end
function c98346582.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98346582.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98346582.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c98346582.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xaf7)
end
function c98346582.splimit(e,se,sp,st,spos,tgp)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)~=SUMMON_TYPE_SYNCHRO or Duel.GetFlagEffect(tgp,98346582)==0
end
function c98346582.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98346582.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c98346582.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c98346582.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98346583)==0
end
function c98346582.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and e:GetHandler():IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c98346582.hdop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	else
		if e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsFacedown() then
			Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(98346583,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end