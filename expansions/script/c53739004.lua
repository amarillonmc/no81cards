local m=53739004
local cm=_G["c"..m]
cm.name="异金风暴沙沼城"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.postg)
	e2:SetOperation(cm.posop)
	c:RegisterEffect(e2)
end
function cm.posfilter(c,tp)
	local atk=c:GetBaseAttack()
	if atk%1000~=0 or atk==0 then return false end
	if Duel.GetFlagEffect(tp,m)==0 then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end
	if Duel.GetFlagEffect(tp,m+50)==0 then Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,0,1) end
	local flag=Duel.GetFlagEffectLabel(tp,m)
	local flagx=Duel.GetFlagEffectLabel(tp,m+50)
	local b1=c:GetBaseDefense()>0 and bit.band(flag,0x1)==0
	local b2=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and bit.band(flag,0x2)==0
	local b3=Duel.IsExistingMatchingCard(cm.rthfilter2,tp,0,LOCATION_ONFIELD,1,nil) and c:GetBaseAttack()>=1000 and bit.band(flag,0x4)==0
	local b4=Duel.IsExistingMatchingCard(cm.rthfilter,tp,0,LOCATION_MZONE,1,nil,atk) and bit.band(flag,0x8)==0
	return c:IsFaceup() and c:IsCanTurnSet() and (b1 or b2 or b3 or b4) and bit.band(flagx,1<<(atk/1000))==0
end
function cm.thfilter(c,code)
	return c:IsAttack(1000) and c:IsRace(RACE_ROCK) and not c:IsCode(code) and c:IsAbleToHand()
end
function cm.rthfilter(c,atk)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsAttackBelow(atk)
end
function cm.rthfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.posfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if Duel.GetFlagEffect(tp,m+50)==0 then Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,0,1) end
	local flagx=Duel.GetFlagEffectLabel(tp,m+50)
	Duel.SetFlagEffectLabel(tp,m+50,flagx|1<<(g:GetFirst():GetBaseAttack()/1000))
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsLocation(LOCATION_MZONE) or tc:IsFacedown() then return end
	if Duel.GetFlagEffect(tp,m)==0 then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end
	local flag=Duel.GetFlagEffectLabel(tp,m)
	local off=1
	local ops={}
	local opval={}
	if tc:GetBaseDefense()>0 and bit.band(flag,0x1)==0 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) and bit.band(flag,0x2)==0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.rthfilter2,tp,0,LOCATION_ONFIELD,1,nil) and tc:GetBaseAttack()>=1000 and bit.band(flag,0x4)==0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.rthfilter,tp,0,LOCATION_MZONE,1,nil,tc:GetBaseAttack()) and bit.band(flag,0x8)==0 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local res=0
	if opval[op]==1 then
		res=Duel.Recover(tp,tc:GetBaseDefense()/2,REASON_EFFECT)
		Duel.SetFlagEffectLabel(tp,m,flag|0x1)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		res=Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SetFlagEffectLabel(tp,m,flag|0x2)
	elseif opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,cm.rthfilter2,tp,0,LOCATION_ONFIELD,1,math.floor(tc:GetBaseAttack()/1000),nil)
		Duel.HintSelection(dg)
		res=Duel.SendtoHand(dg,nil,REASON_EFFECT)
		Duel.SetFlagEffectLabel(tp,m,flag|0x4)
	elseif opval[op]==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rg=Duel.SelectMatchingCard(tp,cm.rthfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetBaseAttack())
		Duel.HintSelection(rg)
		res=Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.SetFlagEffectLabel(tp,m,flag|0x8)
	end
	if res>0 and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
