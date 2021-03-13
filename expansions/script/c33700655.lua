if not pcall(function() require("expansions/script/c33700650") end) then require("script/c33700650") end
--破天神狐 贰伍〇〇·七六六九六五七二
local m=33700655
local cm=_G["c"..m]
cm.named_with_ptsh=true
function cm.initial_effect(c)
	local e1=sr_ptsh.Cmeffect(c,m)
	
	local e2=sr_ptsh.efeffect(c,m,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE,EVENT_CHAINING,EFFECT_FLAG_DELAY)

	local e3=sr_ptsh.opeffect(c,m)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==1-tp and loc~=LOCATION_ONFIELD
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_DECK,c)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and #g>10 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_DECK,c)
	local ct=11
	if #g<11 then
		ct=#g
	end
	local tt=g:Select(1-tp,ct,ct,REASON_EFFECT)
	Duel.SendtoGrave(tt,REASON_EFFECT)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.geteffect(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	e5:SetCondition(cm.descon)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return sr_ptsh.check_set_ptsh(re:GetHandler()) 
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
end