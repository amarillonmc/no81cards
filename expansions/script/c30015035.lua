--归墟奇裂点
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015035,"Overuins")
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e30)
	--Effect 1  
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(30015035)
	--e1:SetRange(LOCATION_FZONE)
	--e1:SetTargetRange(1,0)
	--c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.immtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e9=e1:Clone()
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetValue(aux.indoval)
	c:RegisterEffect(e9)
	--Effect 2 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(cm.reccon)
	e7:SetOperation(cm.recop)
	c:RegisterEffect(e7)
	--Effect 3 
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetCondition(cm.spcon)
	e21:SetTarget(cm.sptg)
	e21:SetOperation(cm.spop)
	c:RegisterEffect(e21) 
end
--Effect 1
function cm.immtg(e,c)
	return rk.check(c,"Overuins") and c~=e:GetHandler()
end
--Effect 2
function cm.downremovefilter(c,player)
	return c:IsAbleToRemove(1-player,POS_FACEDOWN)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local player=e:GetHandlerPlayer()
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,player,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,1-player,POS_FACEDOWN) 
		and Duel.SelectYesNo(1-player,aux.Stringid(30015500,1)) 
		and Duel.IsPlayerCanRemove(1-player) then
		local g=Duel.GetFieldGroup(1-player,0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
		if #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			Duel.ConfirmCards(1-player,g)
			Duel.Hint(HINT_SELECTMSG,1-player,HINTMSG_REMOVE)
			local sg=g:FilterSelect(1-player,aux.NecroValleyFilter(cm.downremovefilter),1,3,nil,player,POS_FACEDOWN)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			Duel.ShuffleDeck(player)
			Duel.ShuffleExtra(player)
		end
	end
end
function cm.cfilter(c)
	return  c:IsSummonType(SUMMON_TYPE_ADVANCE) 
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil) and e:GetHandler():GetFlagEffect(m)==0
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0))  then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil)
			local s2=tc:IsMSetable(true,nil)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil)
			else
				Duel.MSet(tp,tc,true,nil)
			end
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end		
	end
end
--Effect 3 
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	local rc=c:GetReasonCard()
	local re=c:GetReasonEffect()
	if not rc and re then
		local sc=re:GetHandler()
		if not rc then
			Duel.SetTargetCard(sc)
			sg:AddCard(sc)
		end
	end 
	if rc then 
		Duel.SetTargetCard(rc)
		sg:AddCard(rc)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if sc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and sc:GetOwner()==1-tp then
		local rg=Group.FromCards(sc,c)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	elseif sc:IsRelateToEffect(e) and sc:GetOwner()==1-tp then
		Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	elseif c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)   
	end
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() 
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,2,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.thfilter(c)
	return c:IsFacedown() and rk.check(c,"Overuins") and c:IsAbleToHand()
end
