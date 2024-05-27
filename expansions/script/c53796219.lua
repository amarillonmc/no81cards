if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.check)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.check(e,tp,eg,ep,ev,re,r,rp)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAIN_SOLVING,true)
	if not tre then return end
	if tre:GetHandler():IsCode(53796216) then re:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,53796216) end
	if tre:GetHandler():IsCode(53796217) then re:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,53796217) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local b=false
	if re and re:GetHandler():GetFlagEffect(id)>0 then
		local t={re:GetHandler():GetFlagEffectLabel(id)}
		if re:GetHandler():IsCode(53796216) and SNNM.IsInTable(53796217,t) then b=true end
		if re:GetHandler():IsCode(53796217) and SNNM.IsInTable(53796216,t) then b=true end
	end
	if b then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(s.checkop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		e:SetLabelObject(e1)
		e:SetOperation(s.activate)
	else e:SetOperation(nil) end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()&0x20004~=0 and re:GetHandler()~=e:GetOwner() then e:SetLabel(e:GetLabel()+1) end
end
function s.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:GetSequence()<5
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc1 or tc1:IsImmuneToEffect(e) then return end
	Duel.HintSelection(Group.FromCards(tc1))
	s.atkup(e:GetHandler(),tc1)
	local te=e:GetLabelObject()
	if te and te:GetLabel()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tc2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.BreakEffect()
		if tc2 then Duel.HintSelection(Group.FromCards(tc2)) s.atkup(e:GetHandler(),tc2) end
	end
end
function s.atkup(c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
