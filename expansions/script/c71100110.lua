--死灵法师·终结的爱
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100110
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,4,false)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--imm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--Remove
	local e3=bm.b.ce(c,bm.hint.rmm,CATEGORY_REMOVE,EFFECT_TYPE_IGNITION,nil,1,mz,bm.b.con,cm.cost,cm.tar,cm.op,nil)
	c:RegisterEffect(e3)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(code2) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function cm.efilter(e,te)
	return te:GetHandler():IsCode(71100100)
end
function cm.f(c)
	return (c:IsSetCard(code1) or c:IsSetCard(code2)) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function cm.tf(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsLocation(ga)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetTargetCount(cm.tf,tp,ga,ga,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.f,tp,of,0,1,nil) and rt>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.f,tp,of,0,1,rt,nil)
	local ct=Duel.SendtoGrave(g,bm.re.c)
	e:SetLabel(ct)
end
function cm.tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.tf(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tf,tp,ga,ga,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectTarget(tp,cm.tf,tp,ga,ga,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,ct,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,bm.re.e)~=0 then
		local og=Duel.GetOperatedGroup()
		local c=e:GetHandler()
		if og:GetCount()==0 then return end
		local atk=og:GetSum(Card.GetAttack)/2
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71100111,0,0x4011,atk,atk,12,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP,tp) and Duel.SelectYesNo(tp,bm.hint.sps) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,71100111)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(bm.r.s-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(atk)
			e2:SetReset(bm.r.s-RESET_TOFIELD)
			token:RegisterEffect(e2)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			token:RegisterFlagEffect(m,bm.r.s-RESET_TOFIELD,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_OATH)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetCondition(cm.fcon)
			e1:SetTarget(cm.ftarget)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.fcon(e)
	local tp=e:GetOwnerPlayer()
	return Duel.IsExistingMatchingCard(cm.flagf,tp,of,0,1,nil)
end
function cm.ftarget(e,c)
	return not c:IsCode(71100111)
end
function cm.flagf(c)
	return c:GetFlagEffect(m)>0
end












