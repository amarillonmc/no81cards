if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=SNNM.ScreemEquips(c,EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	local ct=e:GetHandler():GetFlagEffectLabel(53762000) or 0
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	e:GetHandler():ResetFlagEffect(53762000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end
function s.eqcfilter(c,ec)
	local tc=c:GetEquipTarget()
	return tc and tc==ec
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsExists(s.eqcfilter,1,nil,ec) and not eg:IsContains(e:GetHandler())
end
function s.filter1(c,e,tp,g)
	return g:IsContains(c) and c:IsFaceup() and c:GetOriginalType()&0x1==0x1 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,c,c,e,tp)
end
function s.filter2(c,ec,e,tp)
	if not c:IsSetCard(0xc538) or not c:IsType(TYPE_MONSTER) or c:IsCode(ec:GetCode()) then return false end
	local g=Group.FromCards(c,ec)
	return g:IsExists(s.filter,1,nil,g,e,tp) 
end
function s.filter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsAbleToGrave,1,c)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(s.eqcfilter,nil,e:GetHandler():GetEquipTarget())
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1(chkc,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_SZONE,0,1,nil,e,tp,g) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	if g:GetCount()==1 then Duel.SetTargetCard(g) else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		Duel.SelectTarget(tp,s.filter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp,g)
	end
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp):GetFirst()
	if not sc then return end
	local g=Group.FromCards(tc,sc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,s.filter,1,1,nil,g,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.SendtoGrave(g-sg,REASON_EFFECT)
	end
end
