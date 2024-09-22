--魔王的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf7),aux.NonTuner(Card.IsSetCard,0xaf7),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98346598,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(c98346598.eqtg)
	e1:SetOperation(c98346598.eqop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346598,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(c98346598.sptg)
	e2:SetOperation(c98346598.spop)
	c:RegisterEffect(e2)
end
function c98346598.eqfilter(c)
	return c:IsSetCard(0xaf7) and not c:IsForbidden()
end
function c98346598.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c98346598.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c98346598.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c98346598.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c98346598.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c98346598.eqlimit(e,c)
	return e:GetOwner()==c
end
function c98346598.spfilter(c,e,tp)
	return c:IsType(TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0xaf7,TYPE_MONSTER+TYPE_NORMAL,2500,1600,8,0x8,0x20,POS_FACEUP)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP) and c:IsSetCard(0xaf7)
end
function c98346598.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98346598.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98346598.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c98346598.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c98346598.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tg=sg:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_FIEND)
		tg:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		tg:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(2500)
		tg:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(1600)
		tg:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(8)
		tg:RegisterEffect(e6,true)
		tg:RegisterFlagEffect(98346598,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_END,0,1,fid)
		tg=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	sg:KeepAlive()
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_PHASE+PHASE_END)
	de:SetReset(RESET_PHASE+PHASE_END)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	de:SetCountLimit(1)
	de:SetLabel(fid)
	de:SetLabelObject(sg)
	de:SetOperation(c98346598.desop)
	Duel.RegisterEffect(de,tp)
end
function c98346598.desfilter(c,fid)
	return c:GetFlagEffectLabel(98346598)==fid
end
function c98346598.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(c98346598.desfilter,nil,fid)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
	local tg2=tg:Filter(c98346598.desfilter,nil,fid)
	Duel.SendtoGrave(tg2,REASON_EFFECT)
end
