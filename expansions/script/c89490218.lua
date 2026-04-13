--恐吓爪牙族的超克
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(s.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e4)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function s.filter1(c,e,tp)
	return c:IsReleasable() and c:IsSetCard(0x17a) and c:IsType(TYPE_LINK) and c:GetSequence()>4 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.filter2(c,e,tp,mc)
	return c:IsSetCard(0x17a) and c:IsType(TYPE_LINK) and c:GetOriginalCodeRule()~=mc:GetOriginalCodeRule() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.CheckReleaseGroup(tp,s.filter1,1,nil,e,tp) end
	local rg=Duel.SelectReleaseGroup(tp,s.filter1,1,1,nil,e,tp)
	e:SetLabelObject(rg:GetFirst())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousSetCard(0x17a) and c:IsType(TYPE_LINK) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.spcfilter(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function s.thfilter(c,e,tp)
	return c:IsCode(82361809) and c:IsFaceupEx() and (c:IsAbleToHand() or Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	local sg=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local op=aux.SelectFromOptions(tp,{tc:IsAbleToHand(),1190},{Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false),1152})
		if op==1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
