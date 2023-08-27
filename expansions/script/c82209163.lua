--炽金战兽 依瑞蒂
local m=82209163
local cm=c82209163
function cm.initial_effect(c)
	--common spsummon effect  
	local e0=Effect.CreateEffect(c)  
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e0:SetCode(EVENT_TO_GRAVE)  
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e0:SetCondition(cm.cmcon)  
	e0:SetTarget(cm.cmtg)  
	e0:SetOperation(cm.cmop)  
	c:RegisterEffect(e0) 
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--cannot target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET) 
	e2:SetCondition(cm.con)
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)  
end

--common
function cm.cmcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_MZONE) 
			and bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0 
			and c:IsPreviousPosition(POS_FACEUP) 
			and rp==1-tp and c:GetPreviousControler()==tp
end  
function cm.cmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.cmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then 
			--change race
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(RACE_BEAST)
			c:RegisterEffect(e1)
			--change base attack
			local atk=c:GetBaseAttack()
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,1))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e2:SetValue(atk*2)
			c:RegisterEffect(e2)
			--redirect
			local e3=Effect.CreateEffect(c)  
			e3:SetDescription(aux.Stringid(m,2))
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e3:SetValue(LOCATION_DECKBOT)  
			c:RegisterEffect(e3)  
			Duel.SpecialSummonComplete()
		end 
	end  
end  

--to grave
function cm.tgfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x5294)
end  
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.tgfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)  
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_REMOVED,0,1,2,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)  
	if sg:GetCount()>0 then  
		local ct=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)  
		if ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,ct,nil,tp)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end  
end  

--cannot target
function cm.con(e)
	return e:GetHandler():IsRace(RACE_BEAST)
end