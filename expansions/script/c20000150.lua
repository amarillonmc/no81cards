--概念虚械 仁爱
local m=20000150
local cm=_G["c"..m]
fu_cim=fu_cim or {}
-------------------------------xyz
function fu_cim.XyzUnite(c,code,Give)
--Unite
	fu_cim.XyzProcedure(c,code)
	local e1=fu_cim.GetMaterial(c)
	local e2=fu_cim.GiveEffect(c,Give)
	return e1,e2
end
function fu_cim.XyzProcedure(c,code)
--xyz procedure
	aux.AddXyzProcedure(c,nil,11,2,fu_cim.Xyz_Material,aux.Stringid(m,0),99,fu_cim.Xyz_EXMaterial(code))
	c:EnableReviveLimit()
end
function fu_cim.GetMaterial(c)
--get material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(fu_cim.GetMaterial_tg)
	e1:SetOperation(fu_cim.GetMaterial_op)
	c:RegisterEffect(e1)
	return e1
end
function fu_cim.GiveEffect(c,Give)
--be remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE) --EVENT_DETACH_MATERIAL
	e1:SetCondition(fu_cim.GiveEffect_con)
	e1:SetOperation(fu_cim.GiveEffect_op(Give))
	c:RegisterEffect(e1)
	return e1
end
-------------------------------
function fu_cim.Hint(c,code)
--下级的效果提示文字
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetCode(EVENT_ADJUST)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetOperation(fu_cim.Hint_op(code))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(fu_cim.DisHint_con)
	e2:SetOperation(fu_cim.DisHint_op(code))  
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
end
function fu_cim.Remove_Material_condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ)
end
function fu_cim.Remove_Material_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(fu_cim.Remove_Material_cost_filter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20000162,2))
	local tc=g:Select(tp,1,1,nil):GetFirst()
	tc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function fu_cim.SpecialSummon_limit(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(fu_cim.SpecialSummon_limit_tg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
-------------------------------
function fu_cim.Xyz_Material(c)
	return c:IsFaceup() and c:IsSetCard(0xafd1)
end
function fu_cim.Xyz_EXMaterial(code)
	return  function(e,tp,chk)
				if chk==0 then return Duel.GetFlagEffect(tp,code)==0 end
				Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
			end
end
function fu_cim.GetMaterial_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsCanOverlay() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,1,nil)
end
function fu_cim.GetMaterial_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsType(TYPE_XYZ) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function fu_cim.GiveEffect_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function fu_cim.GiveEffect_op(Give)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local tc=re:GetHandler()
				if not tc:IsOnField() then return end
				if Give then Give(tc) end
			end
end
function fu_cim.Hint_op(code)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if e:GetHandler():IsSetCard(0xcfd1) and e:GetHandler():IsType(TYPE_XYZ) then
					e:GetHandler():RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
				end
			end
end
function fu_cim.DisHint_con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_OVERLAY)  
end
function fu_cim.DisHint_op(code)
	return  function(e,tp,eg,ep,ev,re,r,rp) 
				local tp=e:GetHandler():GetControler() 
				local c=e:GetHandler() 
				local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_XYZ)
				local tc=g:GetFirst()
				while tc do
					tc:ResetFlagEffect(code)
					tc=g:GetNext()
				end
				Duel.Readjust()
			end
end
function fu_cim.Remove_Material_cost_filter(c,tp)
	return c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function fu_cim.SpecialSummon_limit_tg(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
-------------------------------
if not cm then return end
function cm.initial_effect(c)
	local e1=fu_cim.XyzUnite(c,m,cm.Give)
end
function cm.Give(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()/2
	if chk==0 then return atk>0 end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and (c:GetAttack()/2)>0 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Recover(p,c:GetAttack()/2,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.op1va)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.op1va(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end