--SCP-682 不灭孽蜥
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102001,"SCP")
local kh=c16102001
function kh.initial_effect(c)
	 c:EnableReviveLimit()
	--leave F 
	local e0=rsef.SV_REDIRECT(c,"leave",LOCATION_HAND,rscon.excard2(rscf.CheckSetCard,LOCATION_ONFIELD,0,1,nil,"SCP_J"))
	--SpecialSummonRule
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon,cm.sprop)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16102001,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(kh.discon)
	e3:SetTarget(kh.distg)
	e3:SetOperation(kh.disop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16102001,4))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(kh.condition)
	e4:SetTarget(kh.target)
	e4:SetOperation(kh.operation)
	c:RegisterEffect(e4)
end
function kh.lecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(kh.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spcfilter(c,tp)
	return c:IsReleasable() and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.spcfilter2(c,tp)
	return c:IsControler(tp) and c:IsCode(16102002) 
end
function cm.spzfilter(g,tp)
	if Duel.GetMZoneCount(tp,g,tp)<=0 then return false end
	return g:FilterCount(cm.spcfilter2,nil,tp)==2 or (#g==1 and g:IsExists(cm.spcfilter,1,nil,tp))
end
function cm.sprcon(e,c,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	return (g1+g2):CheckSubGroup(cm.spzfilter,1,2,tp)
end
function cm.sprop(e,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	rshint.Select(tp,"res")
	local sg=(g1+g2):SelectSubGroup(tp,cm.spzfilter,false,1,2,tp)
	Duel.Release(sg,REASON_COST)
end
function kh.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and  Duel.IsChainDisablable(ev) 
end
function kh.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function kh.disop(e,tp,eg,ep,ev,re,r,rp)
	local tpe=bit.band(re:GetActiveType(),0x7)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabel(tpe)
			e1:SetValue(kh.efilter)
			e1:SetOwnerPlayer(tp)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
	end
	--if  not Duel.IsExistingMatchingCard(kh.cfilter,tp,LOCATION_GRAVE,0,1,nil) then return end
	--if Duel.SelectYesNo(tp,aux.Stringid(16102001,7)) then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		--local g=Duel.SelectMatchingCard(tp,kh.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		--Duel.SendtoHand(g,nil,REASON_EFFECT)
	--end
end
function kh.efilter(e,re)
	local tpe=e:GetLabel()
	return tpe==re:GetHandler():GetType()
end
function kh.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function kh.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function kh.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
	local op=Duel.SelectOption(tp,aux.Stringid(16102001,2),aux.Stringid(16102001,3))
		if op==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(bc:GetTextAttack())
			c:RegisterEffect(e1) 
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetDescription(aux.Stringid(16102001,6))
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2,true)
		end
		if op==1 then
			local code=bc:GetOriginalCodeRule()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_ADD_CODE)
			e1:SetValue(code)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetDescription(aux.Stringid(16102001,5))
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e2,true)
			if not bc:IsType(TYPE_TRAPMONSTER) then
				local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			end
		end
	end
end
function kh.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end