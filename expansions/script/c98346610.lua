--英雄的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsSetCard,0xaf7),aux.Tuner(Card.IsSetCard,0xaf7),nil,aux.NonTuner(Card.IsSetCard,0xaf7),1,99)
	c:EnableReviveLimit()
	--spsummonlimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98346610,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(c98346610.rmcon)
	e1:SetTarget(c98346610.rmtg)
	e1:SetOperation(c98346610.rmop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98346610,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(c98346610.efcon1)
	e3:SetTarget(c98346610.sptg)
	e3:SetOperation(c98346610.spop)
	c:RegisterEffect(e3)
	--ToGrave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98346610,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+o*2)
	e4:SetCondition(c98346610.efcon2)
	e4:SetTarget(c98346610.tgtg)
	e4:SetOperation(c98346610.tgop)
	c:RegisterEffect(e4)
	--Draw		
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98346610,3))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+o*3)
	e5:SetCondition(c98346610.efcon3)
	e5:SetTarget(c98346610.drtg)
	e5:SetOperation(c98346610.drop)
	c:RegisterEffect(e5)
end
function c98346610.efcon1(e)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,0xaf7)
	return ct>=1
end
function c98346610.efcon2(e)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,0xaf7)
	return ct>=2
end
function c98346610.efcon3(e)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,0xaf7)
	return ct>=3
end
function c98346610.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98346610.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c98346610.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c98346610.spfilter(c,e,tp)
	return c:IsSetCard(0xaf7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98346610.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c98346610.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98346610.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98346610.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98346610.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSetCard(0xaf7) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98346610.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c98346610.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c98346610.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98346610.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
