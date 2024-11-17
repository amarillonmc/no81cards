--[[绝体绝命810！←狂舞的妖天岚！
BranD-810! Celestial Whirlwind!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end

local FLAG_ZERO_ATK = id
local FLAG_ZERO_DEF = id+100
local FLAG_ACTIVATED_ST = id+200

function s.initial_effect(c)
	c:Activation()
	--[[Each time a "Brand-810!" monster(s) you control is sent to the GY, all monsters your opponent controls immediately lose ATK and DEF equal to the
	total ATK and DEF of that monster(s), respectively]]
	aux.RegisterMaxxCEffect(c,id,nil,LOCATION_FZONE,EVENT_TO_GRAVE,s.reccon,s.recopOUT,s.recopIN,s.flaglabel,false,false,nil,aux.AddThisCardInFZoneAlreadyCheck(c))
	--[[While your opponent controls a monster whose ATK was reduced to 0 by this card's effect, they cannot Special Summon more than 1 monster per turn]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(59822133)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.splimcon)
	c:RegisterEffect(e1)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_FIELD)
	e1x:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1x:SetRange(LOCATION_FZONE)
	e1x:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1x:SetTargetRange(0,1)
	e1x:SetCondition(s.splimcon)
	e1x:SetValue(1)
	c:RegisterEffect(e1x)
	--[[While your opponent controls a monster whose DEF was reduced to 0 by this card's effect, they cannot activate more than 1 Spell/Trap Card per turn]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(s.aclimit1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(s.aclimit2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(s.econ)
	e5:SetValue(s.elimit)
	c:RegisterEffect(e5)
	--[[If this card is sent from the field to the GY: You can Set a "BranD-810!" Field Spell, except "BranD-810! Celestial Whirlwind!" from your Deck
	in your Field Zone, but it cannot be activated this turn.]]
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetFunctions(s.setcon,nil,s.settg,s.setop)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_ADJUST)
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
	end
end

function s.resetfilter(c)
	return c:HasFlagEffect(FLAG_ZERO_ATK) and c:GetAttack()~=0 or (c:HasFlagEffect(FLAG_ZERO_DEF) and c:GetDefense()~=0)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.resetfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	for c in aux.Next(g) do
		if c:GetAttack()~=0 then
			c:ResetFlagEffect(FLAG_ZERO_ATK)
		end
		if c:GetDefense()~=0 then
			c:ResetFlagEffect(FLAG_ZERO_DEF)
		end
	end
end

--E1
function s.cfilter(c,p)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(p) and c:IsPreviousPosition(POS_FACEUP) 
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(aux.AlreadyInRangeFilter(e,s.cfilter),1,nil,tp)
end
function s.flaglabel(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(aux.AlreadyInRangeFilter(e,s.cfilter),nil,tp)
	local atk,def=g:GetSum(Card.GetPreviousAttackOnField),g:GetSum(Card.GetPreviousDefenseOnField)
	return atk|(def<<16)
end
function s.recopOUT(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.Group(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #sg==0 then return end
	Duel.Hint(HINT_CARD,tp,id)
	local g=eg:Filter(aux.AlreadyInRangeFilter(e,s.cfilter),nil,tp)
	local atk,def=g:GetSum(Card.GetPreviousAttackOnField),g:GetSum(Card.GetPreviousDefenseOnField)
	if atk==0 and def==0 then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	for tc in aux.Next(sg) do
		local e1,e2,atkdiff,defdiff=tc:UpdateATKDEF(-atk,-def,true,{c,true})
		if e1 and atkdiff<0 and not tc:IsImmuneToEffect(e1) and tc:GetAttack()==0 then
			tc:RegisterFlagEffect(FLAG_ZERO_ATK,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,fid,aux.Stringid(id,0))
		end
		if e2 and defdiff<0 and not tc:IsImmuneToEffect(e2) and tc:GetDefense()==0 then
			tc:RegisterFlagEffect(FLAG_ZERO_DEF,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,fid,aux.Stringid(id,1))
		end
	end
end
function s.recopIN(e,tp,eg,ep,ev,re,r,rp,n)
	local sg=Duel.Group(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #sg==0 then return end
	Duel.Hint(HINT_CARD,tp,id)
	local labels={Duel.GetFlagEffectLabel(tp,id)}
	local atk,def=0,0
	for i=1,#labels do
		local val=labels[i]
		local tatk,tdef=val&0xffff,val>>16
		atk,def=atk+tatk,def+tdef
	end
	if atk==0 and def==0 then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	for tc in aux.Next(sg) do
		local e1,e2,atkdiff,defdiff=tc:UpdateATKDEF(-atk,-def,true,{c,true})
		if e1 and atkdiff<0 and not tc:IsImmuneToEffect(e1) and tc:GetAttack()==0 then
			tc:RegisterFlagEffect(FLAG_ZERO_ATK,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,fid,aux.Stringid(id,0))
		end
		if e2 and defdiff<0 and not tc:IsImmuneToEffect(e2) and tc:GetDefense()==0 then
			tc:RegisterFlagEffect(FLAG_ZERO_DEF,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,fid,aux.Stringid(id,1))
		end
	end
end

--E1
function s.splimcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExists(false,Card.HasFlagEffectLabel,tp,0,LOCATION_MZONE,1,nil,FLAG_ZERO_ATK,e:GetHandler():GetFieldID())
end

--E3
function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(FLAG_ACTIVATED_ST,RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_CONTROL|RESET_PHASE|PHASE_END,0,1)
end
function s.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(FLAG_ACTIVATED_ST)
end
function s.econ(e)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetFlagEffect(FLAG_ACTIVATED_ST)~=0 and Duel.IsExists(false,Card.HasFlagEffectLabel,tp,0,LOCATION_MZONE,1,nil,FLAG_ZERO_ATK,e:GetHandler():GetFieldID())
end
function s.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end

--E6
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.setfilter(c)
	return c:IsSpell(TYPE_FIELD) and c:IsSetCard(ARCHE_BRAND_810) and not c:IsCode(id) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc,tp,false)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		sc:RegisterEffect(e1)
	end
end