--近心芽姬·巡界 莫洛
local s,id,o=GetID()
Duel.LoadScript("GearGal.lua")
function s.initial_effect(c)
	GearGal.AddNearGalEffects(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter(c,tp) return c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x1449) end
function s.condition(e,tp,eg,ep,ev,re,r,rp) local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) return rp~=tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsExists(s.filter,1,nil,tp) end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(s.filter,nil,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET) local tc=g:Select(tp,1,1,nil):GetFirst() Duel.SetTargetCard(tc)
end
function s.operation(e,tp)
	local c=e:GetHandler() local tc=Duel.GetFirstTarget() if not tc or not tc:IsRelateToEffect(e) then return end
	local moved=false
	if tc:IsLocation(LOCATION_MZONE) then moved=GearGal.PlaceAsContinuousSpell(tc,tp)
	elseif tc:IsLocation(LOCATION_SZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then moved=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 end
	if moved and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		for _,code in ipairs({EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_XYZ_MATERIAL}) do local ex=Effect.CreateEffect(c) ex:SetType(EFFECT_TYPE_SINGLE) ex:SetCode(code) ex:SetValue(1) ex:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) c:RegisterEffect(ex) end
		local e1=Effect.CreateEffect(c) e1:SetType(EFFECT_TYPE_SINGLE) e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL) e1:SetValue(s.linklimit) e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) c:RegisterEffect(e1)
	end
end
function s.linklimit(e,c) return not c:IsSetCard(0x3449) end
