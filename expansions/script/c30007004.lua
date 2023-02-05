--电子暗黑角盔
local m=30007004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_DESTROY+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.dthcost)
	e1:SetTarget(cm.dthtg)
	e1:SetOperation(cm.dthop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m+m)
	e2:SetCondition(cm.gycon)
	e2:SetOperation(cm.gyop)
	c:RegisterEffect(e2)
	--Effect 3
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
--Effect 1
function cm.f(c)
	return c:IsRace(RACE_MACHINE+RACE_DRAGON) and c:IsDiscardable(REASON_EFFECT)
end
function cm.f1(c)
	return c:IsSetCard(0x4093) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.dthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.dthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(cm.f,tp,LOCATION_HAND,0,c)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local shg=Duel.GetMatchingGroup(cm.f1,tp,LOCATION_DECK,0,nil)
	local shchk=shg:FilterCount(Card.IsAbleToHand,nil)>0 and shg:FilterCount(Card.IsAbleToGrave,nil)>0
	if chk==0 then return #hg>0 and #dg>1 and shchk and #shg>1 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,shg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,shg,1,0,0)
end
function cm.dthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(cm.f,tp,LOCATION_HAND,0,c)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local shg=Duel.GetMatchingGroup(cm.f1,tp,LOCATION_DECK,0,nil)
	local sshg=shg:Filter(cm.hf,nil,shg)
	if #hg==0 or #dg==0 or #sshg<2 then return end
	local dct=#hg
	if #hg>(#dg-1) then dct=#dg-1 end
	if dct>(#sshg-1) then dct=#sshg-1 end
	if Duel.DiscardHand(tp,cm.f,1,dct,REASON_EFFECT+REASON_DISCARD,c)==0 then return false end
	local og=Duel.GetOperatedGroup()
	if #og==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tag=dg:Select(tp,#og+1,#og+1,nil)
	if #tag==0 then return false end
	Duel.HintSelection(tag)
	local ct=Duel.Destroy(tag,REASON_EFFECT)
	if ct==0 then return false end
	shg=Duel.GetMatchingGroup(cm.f1,tp,LOCATION_DECK,0,nil)
	sshg=shg:Filter(cm.hf,nil,shg)
	if #sshg<ct then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local thg=sshg:FilterSelect(tp,cm.hf,ct,ct,nil,sshg)
	if #thg<2 then return false end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=thg:FilterSelect(tp,cm.hf,1,1,nil,thg)
	if #tg==0 then return false end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	Duel.SendtoGrave(thg-tg,REASON_EFFECT)
end
function cm.hf(c,g)
	return c:IsAbleToHand() and g:FilterCount(Card.IsAbleToGrave,c)==#g-1
end
--Effect 2
function cm.gycon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget())
end
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and ec:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e1:SetCondition(cm.damcon)
		e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e1:SetLabel(e:GetHandlerPlayer())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)
		ec:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.damcon(e)
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil and bc:GetControler()~=e:GetLabel()
end
--Effect 3 
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousEquipTarget() and not c:IsReason(REASON_LOST_TARGET)
end
function cm.ef(c,tp)
	return c:IsRace(RACE_DRAGON+RACE_MACHINE) and c:CheckUniqueOnField(tp,LOCATION_ONFIELD) and not c:IsForbidden()
end
function cm.eqf(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x4093)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(cm.eqf,tp,LOCATION_MZONE,0,nil)
	local equipg=Duel.GetMatchingGroup(cm.ef,tp,LOCATION_GRAVE,LOCATION_GRAVE,e:GetHandler(),tp)
	if chk==0 then return ft>0 and #g>0 and #equipg>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,equipg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,equipg,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(cm.eqf,tp,LOCATION_MZONE,0,nil)
	local equipg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.ef),tp,LOCATION_GRAVE,LOCATION_GRAVE,c,tp)
	if #g==0 or #equipg==0 or ft==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tag=g:Select(tp,1,1,nil)
	if #tag==0 then return false end
	Duel.HintSelection(tag)
	local tc=tag:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=equipg:Select(tp,1,1,nil):GetFirst()
	if tc and ec and Duel.Equip(tp,ec,tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1600)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end