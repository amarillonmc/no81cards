--在水之湄
local cm, m, ofs = GetID()
local yr = 13020010
xpcall(function() dofile("expansions/script/c16670000.lua") end,function() dofile("script/c16670000.lua") end)--引用库
function cm.initial_effect(c)
	aux.AddCodeList(c, yr)
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
	local e1=xg.epp2(c,m,4,EVENT_EQUIP,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY,QY_mx,nil,nil,cm.target,cm.operation,true)
	e1:SetCountLimit(1,m)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.cost1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter1)
	c:RegisterEffect(e4)
end
function cm.efilter1(e,te)
	local ec=e:GetHandler():GetEquipTarget()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not(g~=nil and g:IsContains(ec))
	--return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_COST)
end
function cm.filter(c)
	return c:IsCode(yr) and c:IsAbleToHand()
end
function cm.filter1(c,ec,c2)
	return c:GetEquipTarget()==ec and c==c2
end
function cm.filter2(c,ec,c2)
	return c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	--local dg=eg:Filter(cm.filter1,nil,tc,c)
	local g1 = Duel.GetMatchingGroup( cm.filter2, tp, LOCATION_ONFIELD+LOCATION_GRAVE, LOCATION_ONFIELD+LOCATION_GRAVE, nil)
	if chk==0 then return tc and #g1>0 and c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,2,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) then return end
	local g=Group.CreateGroup()
	local g1 = Duel.SelectMatchingCard(tp, cm.filter2, tp, LOCATION_ONFIELD+LOCATION_GRAVE, LOCATION_ONFIELD+LOCATION_GRAVE,1,1, nil):GetFirst()
	g:AddCard(g1)
	g:AddCard(c)
	Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
	if g1:IsLocation(QY_cw) and g1:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.spcon)
		e1:SetOperation(cm.spop)
		e1:SetRange(LOCATION_REMOVED)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		g1:RegisterEffect(e1, true)
	end
if g1:IsLocation(QY_cw) and not g1:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.spcon2)
		e1:SetOperation(cm.spop2)
		e1:SetRange(LOCATION_REMOVED)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		g1:RegisterEffect(e1, true)
	end
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and tp==Duel.GetTurnPlayer()
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tp==Duel.GetTurnPlayer()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function cm.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp)
		and rp==1-tp and c:IsType(TYPE_EQUIP)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function cm.filter6(c,e,tp,id,g)
	return c:IsCanBeEffectTarget(e) and #g:Filter(cm.filter4, nil,c)~=0
end
function cm.filter5(c,e,tp,tc)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(m) and aux.IsCodeListed(c, yr) and c:IsSSetable()
end
function cm.filter4(c,c2)
	return c2:CheckEquipTarget(c) and not c:IsCode(m) and aux.IsCodeListed(c, yr)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g2 = Duel.GetMatchingGroup( cm.filter5, tp, QY_kz, 0, nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,QY_mx)>0 and #g2>0 end
end

function cm.con4_4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.op4_5(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then return end
	local e4_5_1=tc:GetActivateEffect()
	e4_5_1:SetProperty(nil)
	e4_5_1:SetHintTiming(0)
	e4_5_1:SetCondition(aux.TRUE)
	e:Reset()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2 = Duel.SelectMatchingCard(tp, cm.filter5, tp, QY_kz, 0,1,1, nil,e,tp):GetFirst()
	if Duel.SSet(tp, g2 ,tp)~=0 then
		if c:IsType(TYPE_TRAP+TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g2:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			g2:RegisterEffect(e2)
		else
			local tc=g2
			local e4_4=g2:GetActivateEffect()
			if e4_4~=nil then
				e4_4:SetProperty(e4_4:GetProperty(),EFFECT_FLAG2_COF)
				e4_4:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
				local oq=e4_4:GetCondition()
				local ow=e4_4:GetProperty()
				e4_4:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
					return Duel.GetCurrentChain()==0 and (not oq or oq(e,tp,eg,ep,ev,re,r,rp))
				end)
				tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
				local e4_5=Effect.CreateEffect(c)
				e4_5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e4_5:SetCode(EVENT_ADJUST)
				e4_5:SetOperation(function (e,tp,eg,ep,ev,re,r,rp)
					local tc=e:GetLabelObject()
					if tc:GetFlagEffect(m)~=0 then return end
					local e4_5_1=tc:GetActivateEffect()
					e4_5_1:SetProperty(ow)
					e4_5_1:SetHintTiming(table.unpack(ow))
					e4_5_1:SetCondition(oq)
					e:Reset()
				end)
				e4_5:SetLabelObject(g2)
				Duel.RegisterEffect(e4_5,tp)
			end
		end
	end
end
