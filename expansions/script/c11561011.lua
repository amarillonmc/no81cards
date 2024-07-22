--缔结之红莲 古蕾娅
function c11561011.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11561011.mfilter,c11561011.xyzcheck,2,2)	
	--to grave atk 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(11561011,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11561011) 
	e1:SetTarget(c11561011.tgtg) 
	e1:SetOperation(c11561011.tgop) 
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561011,2))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21561011)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) end) 
	e2:SetTarget(c11561011.xxtg)
	e2:SetOperation(c11561011.xxop)
	c:RegisterEffect(e2) 
	--atk 
	--local e3=Effect.CreateEffect(c) 
	--e3:SetDescription(aux.Stringid(11561011,3))
	--e3:SetType(EFFECT_TYPE_QUICK_O) 
	--e3:SetCode(EVENT_CHAINING) 
	--e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e3:SetRange(LOCATION_MZONE) 
	--e3:SetCondition(c11561011.atkcon) 
	--e3:SetTarget(c11561011.atktg)
	--e3:SetOperation(c11561011.atkop) 
	--c:RegisterEffect(e3)
	--pendulum
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c11561011.pencon)
	e3:SetTarget(c11561011.pentg)
	e3:SetOperation(c11561011.penop)
	c:RegisterEffect(e3) 
	--to hand
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE) 
	e1:SetTarget(c11561011.patktg)
	e1:SetOperation(c11561011.patkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c11561011.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,8) 
end
function c11561011.xyzcheck(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount() 
end
function c11561011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end  
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3) 
end 
function c11561011.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.DiscardDeck(tp,3,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=20 and c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1200)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e1)	 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1200)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e1)	 
	end 
end 
function c11561011.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsExistingMatchingCard(c11561011.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)   
end 
function c11561011.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()   
	if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.DiscardDeck(tp,3,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=20 then 
		for i=1,9 do 
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)   
			if g:GetCount()>0 then 
				local tc=g:RandomSelect(tp,1):GetFirst() 
				local pratk=tc:GetAttack() 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE)  
				e1:SetCode(EFFECT_UPDATE_ATTACK) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(-400)  
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
				tc:RegisterEffect(e1)   
				if pratk~=0 and tc:GetAttack()==0 and aux.NegateEffectMonsterFilter(tc) then 
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
					Duel.AdjustInstantly()
					Duel.NegateRelatedChain(tc,RESET_TURN_SET) 
					Duel.Destroy(tc,REASON_EFFECT)  
				end 
			end   
		end 
	end 
end 
function c11561011.atkcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(11561011)<e:GetHandler():GetOverlayCount()
end 
function c11561011.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local rc=re:GetHandler() 
	if chk==0 then return rc~=e:GetHandler() and rc:IsLocation(LOCATION_MZONE) and rc:IsControler(tp) and rc:IsCanBeEffectTarget(e) end 
	Duel.SetTargetCard(rc)  
	e:GetHandler():RegisterFlagEffect(11561011,RESET_EVENT+RESETS_STANDARD,0,1)
end 
function c11561011.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(800)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
	end 
end 
function c11561011.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) 
end
function c11561011.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c11561011.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c11561011.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER+RACE_DRAGON) and c:IsSummonPlayer(tp)
end 
function c11561011.patktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c11561011.cfilter,nil,tp) 
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetTargetCard(g)  
end
function c11561011.patkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		if tc:IsFaceup() then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)
		end 
		tc=g:GetNext()  
		end 
	end 
end  





