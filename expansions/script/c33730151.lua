--[[
键★LB令 - 来个惊喜！
K.E.Y L.B.O - Let's Prepare a Surprise!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_KEYFRAGMENT_LOADED then
	GLITCHYLIB_KEYFRAGMENT_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	c:Activation()
	--[[During damage calculation, if your FIRE "K.E.Y" monster battles: You can send 1 FIRE "K.E.Y" monster from your hand to the GY;
	that monster gains ATK/DEF equal to the sent monster's ATK/DEF, until the end of this turn.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORIES_ATKDEF)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.atkcon)
	e1:SetCost(aux.DummyCost)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end

--E1
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetBattleMonster(tp)
	return bc and bc:IsRelateToBattle() and bc:IsFaceup() and bc:IsSetCard(ARCHE_KEY) and bc:IsAttribute(ATTRIBUTE_FIRE)
end
function s.atkcfilter(c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE) and (not c:IsAttack(0) or not c:IsDefense(0)) and c:IsAbleToGraveAsCost()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:IsCostChecked() and Duel.IsExistingMatchingCard(s.atkcfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.atkcfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local atk,def=tc:GetAttack(),tc:GetDefense()
		e:SetLabel(atk,def)
		Duel.SendtoGrave(tc,REASON_COST)
		local bc=Duel.GetBattleMonster(tp)
		Duel.SetTargetCard(bc)
		local p,loc=bc:GetControler(),bc:GetLocation()
		Duel.SetCustomOperationInfo(0,CATEGORY_ATKCHANGE,bc,1,p,loc,atk)
		Duel.SetCustomOperationInfo(0,CATEGORY_DEFCHANGE,bc,1,p,loc,def)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsRelateToBattle() and tc:IsFaceup() then
		local c=e:GetHandler()
		local atk,def=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:UpdateDefenseClone(c,true)
		e2:SetValue(def)
		tc:RegisterEffect(e2)
	end
end