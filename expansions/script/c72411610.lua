--雷格尼斯之主·古蕾娅
function c72411610.initial_effect(c)
	-- as spell
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff)
	e0:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e0)
	--des
		--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,72411610)
	e1:SetTarget(c72411610.thtg)
	e1:SetOperation(c72411610.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
   --def to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,72411611)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c72411610.target2)
	e3:SetOperation(c72411610.operation2)
	c:RegisterEffect(e3)
end
function c72411610.filter(c)
	return c:GetOriginalCode()==72411630 and c:IsAbleToHand()
end
function c72411610.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411610.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72411610.thop(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72411610.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local sn=Duel.SendtoHand(g,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g) 
			if sn~=0 and n<=20 then
			Duel.DiscardDeck(tp,2,REASON_EFFECT)
			local c=e:GetHandler()
				if c:IsRelateToEffect(e) and c:IsFaceup() then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(3000)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
					c:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					c:RegisterEffect(e2)
				end
			end
	end 
end
function c72411610.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and Duel.IsPlayerCanDraw(tp,1)  end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72411610.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.DiscardDeck(p,2,REASON_EFFECT)
	Duel.Draw(p,1,REASON_EFFECT) 
end