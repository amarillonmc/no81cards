--本条二亚的诱惑
function c33400255.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400255)
	e1:SetOperation(c33400255.activate)
	c:RegisterEffect(e1)
	--dm
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,33400255+10000)
	e2:SetCondition(c33400255.dmcon)
	e2:SetOperation(c33400255.dmop)
	c:RegisterEffect(e2)
	 --confirm 1-TP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,33400255+20000)
	e3:SetOperation(c33400255.operation2)
	c:RegisterEffect(e3)
end
function c33400255.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local gm=g:GetCount()
	if gm>0 and Duel.SelectYesNo(tp,aux.Stringid(33400255,0)) then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local g1=Duel.GetDecktopGroup(tp,gm+2)
		Duel.ConfirmCards(tp,g1)
		if g1:IsExists(c33400255.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33400255,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
			local g2=g1:SelectSubGroup(tp,c33400255.check,false,1,3)
			Duel.DisableShuffleCheck()		   
			Duel.SendtoHand(g2,nil,REASON_EFFECT)		   
			Duel.ConfirmCards(1-tp,g2)
			Duel.ShuffleHand(tp)
			Duel.SortDecktop(tp,tp,gm+2-g2:GetCount())
		else Duel.SortDecktop(tp,tp,gm+2) 
		end
	end
end
function c33400255.check(g,c)
	if #g==1 then return true end
	local res=0
	if #g==2 then 
	if g:IsExists(c33400255.check1,1,nil,c) then res=res+1 end
	if g:IsExists(c33400255.check2,1,nil,c) then res=res+4 end
	if g:IsExists(c33400255.check3,1,nil,c) then res=res+100 end
	return res==5 or res==101 or res==104 
	end
	if #g==3 then 
	if g:IsExists(c33400255.check1,1,nil,c) then res=res+1 end
	if g:IsExists(c33400255.check2,1,nil,c) then res=res+4 end
	if g:IsExists(c33400255.check3,1,nil,c) then res=res+100 end
	return  res==105
	end
end
function c33400255.check1(c)
	 return c:IsSetCard(0x6342) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33400255.check2(c)
	 return c:IsSetCard(0x6342) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c33400255.check3(c)
	 return c:IsSetCard(0x6342) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c33400255.thfilter(c)
	return c:IsSetCard(0x6342) and c:IsAbleToHand()
end
function c33400255.thfilter1(c)
	return c:IsSetCard(0x6342) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c33400255.thfilter2(c)
	return c:IsSetCard(0x6342) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c33400255.thfilter3(c)
	return c:IsSetCard(0x6342) and c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c33400255.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c33400255.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateAttack() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local token=Duel.CreateToken(tp,ac)
	local t1=bit.band(token:GetType(),0x7)
	local t2=bit.band(tc:GetType(),0x7)
	if t1==t2  then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else 
		local g4=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g4,nil,REASON_EFFECT)
	end
	if tc:IsCode(ac) then 
	   Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	   if Duel.SelectYesNo(tp,aux.Stringid(33400255,2)) and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then 
			local tc2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)  
			local tc3=tc2:GetFirst()	 
			Duel.Damage(1-tp,tc3:GetBaseAttack()/2,REASON_EFFECT)
	   end
		   if tc:IsSetCard(0x341) and Duel.SelectYesNo(tp,aux.Stringid(33400255,3))then 
			Duel.SendtoGrave(tc,REASON_EFFECT)
		   else  Duel.MoveSequence(tc,1)  
		   end  
	end
end
function c33400255.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if cm>2 then cm=2 end
		local g=Duel.GetDecktopGroup(1-tp,cm)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm)
end