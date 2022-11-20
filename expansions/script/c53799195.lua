local m=53799195
local cm=_G["c"..m]
cm.name="金属绯翠"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_EQUIP)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(function(c,tp,ec)return c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)end,nil,tp,e:GetHandler())
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetChainLimit(function(e,rp,tp)return not e:GetHandler():IsType(TYPE_MONSTER)end)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(function(c,tp,ec)return c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)end,nil,tp,c):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and #g>0 then
		local eqc=g:GetFirst()
		if #g>1 then eqc=g:Select(tp,1,1,nil) end
		if Duel.Equip(tp,eqc,c)~=0 then
			if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				local ug=Duel.GetMatchingGroup(function(c,ec,tp,race)return c:GetOriginalRace()==race and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)end,1-tp,LOCATION_HAND+LOCATION_DECK,0,nil,c,1-tp,eqc:GetOriginalRace())
				if #ug>0 then
					Duel.BreakEffect()
					local uc=ug:Select(1-tp,1,1,nil):GetFirst()
					if Duel.Equip(1-tp,uc,c)~=0 then aux.SetUnionState(uc) end
				else Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,2)) end
			end
		end
	end
end
function cm.fselect(g,e)
	local ct=g:FilterCount(function(c,ug)return c:IsFaceup() and ug:IsContains(c)end,nil,e:GetHandler():GetEquipGroup())
	return #g%2==0 and ct*2>=#g
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return g:CheckSubGroup(cm.fselect,2,#g,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,#g,e)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,#sg,0,0)
	Duel.SetChainLimit(function(e,rp,tp)return not e:GetHandler():IsType(TYPE_MONSTER)end)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end
