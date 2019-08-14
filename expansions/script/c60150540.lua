--幻灭执行官 阿兰玳特
function c60150540.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60150540)
	e2:SetCondition(c60150540.spcon)
	e2:SetOperation(c60150540.spop)
	c:RegisterEffect(e2)
	--封特招
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c60150540.desop2)
	c:RegisterEffect(e3)
	--sp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150540,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c60150540.sptg)
	e4:SetOperation(c60150540.spop2)
	c:RegisterEffect(e4)
end
function c60150540.spfilter(c)
	return c:IsSetCard(0xab20) and c:IsAbleToRemoveAsCost()
end
function c60150540.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150540.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
end
function c60150540.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60150540.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60150540.desop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150540.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150540.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end

function c60150540.cfilter(c,e,tp,al)
	return c:IsSetCard(0xab20) and not c:IsPublic() 
		and Duel.IsExistingTarget(c60150540.lvfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,e,tp,al)
end
function c60150540.lvfilter(c,e,tp,al)
	return Duel.IsExistingMatchingCard(c60150540.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,al,c)
end
function c60150540.xyzfilter(c,e,tp,al,mb)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:GetRank()==10
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
		and al:IsCanBeXyzMaterial(c) and mb:IsCanBeXyzMaterial(c)
end
function c60150540.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150540.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c60150540.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetHandler())
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c60150540.lvfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil,e,tp,e:GetHandler())
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60150540.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() or not (tc:IsRelateToEffect(e) and c:IsRelateToEffect(e)) 
		or (tc:IsImmuneToEffect(e) and c:IsImmuneToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150540.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,tc)
	local sc=g:GetFirst()
	local sg=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	if sc then
		sg:AddCard(tc)
		sg:AddCard(c)
		sg2:Merge(tc:GetOverlayGroup())
		sg2:Merge(c:GetOverlayGroup())
		Duel.SendtoGrave(sg2,REASON_RULE)
		sc:SetMaterial(sg)
		Duel.Overlay(sc,sg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end