local m=33310250
local list={33310257}
local cm=_G["c"..m]
cm.name="梅古梅古"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1])
	--Set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.setcon)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--To Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	e3:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_BATTLE_END)
	c:RegisterEffect(e3)
end
--Set
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return Duel.CheckLocation(tp,LOCATION_SZONE,seq)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if Duel.CheckLocation(tp,LOCATION_SZONE,seq) then
		local token=Duel.CreateToken(tp,list[1])
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true,1<<seq)
		--Direct Attack
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(cm.dirtg)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		--Damage Reduce
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCondition(cm.rdcon)
		e2:SetOperation(cm.rdop)
		token:RegisterEffect(e2)
		--Destroy
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,0))
		e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCountLimit(1)
		e3:SetTarget(cm.destg)
		e3:SetOperation(cm.desop)
		token:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetCode(EFFECT_CHANGE_TYPE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e4:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		token:RegisterEffect(e4)
	end
end
function cm.dirtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x554)
		and aux.GetColumn(c)==aux.GetColumn(e:GetHandler())
end
function cm.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return Duel.GetAttackTarget()==nil and tc:IsFaceup() and tc:IsSetCard(0x554)
		and aux.GetColumn(tc)==aux.GetColumn(e:GetHandler())
		and tc:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,math.floor(ev/2))
end
function cm.desfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==1-tp
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	g:RemoveCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=c:GetColumnGroup()
	g:RemoveCard(c)
	Duel.Destroy(g,REASON_EFFECT)
	if not Duel.GetOperatedGroup():IsExists(cm.desfilter,1,nil,tp) then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
--To Grave
function cm.thfilter(c)
	return c:IsSetCard(0x554) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
		and aux.dscon()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end