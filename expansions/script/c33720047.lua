--百折…… | Troppi Limoni...
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if ep==PLAYER_ALL then
		Duel.RegisterFlagEffect(tp,id,0,0,1)
		Duel.RegisterFlagEffect(1-tp,id,0,0,1)
	else
		Duel.RegisterFlagEffect(ep,id,0,0,1)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)>=100 or Duel.GetFlagEffect(1-tp,id)>=100 end
	local op
	if Duel.GetFlagEffect(tp,id)>=100 and Duel.GetFlagEffect(1-tp,id)>=100 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif Duel.GetFlagEffect(tp,id)>=100 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	local p=(op==0) and tp or 1-tp
	Duel.SetTargetPlayer(p)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	p=(op==0) and p or 1-p
	Duel.Win(p,0x100)
end