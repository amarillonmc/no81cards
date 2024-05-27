if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then Duel.SetChainLimit(aux.FALSE) end
end
function s.filter(c,e,tp)
	if c:IsImmuneToEffect(e) or c:GetSequence()>4 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	c:RegisterEffect(e2)
	local res=false
	local le={c:GetActivateEffect()}
	for _,v in pairs(le) do if v:GetCode()==EVENT_FREE_CHAIN and v:IsActivatable(tp,true) then res=true break end end
	e1:Reset()
	e2:Reset()
	return res
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsCode(53796215) and c:IsStatus(STATUS_EFFECT_ENABLED)end,tp,LOCATION_FZONE,0,1,nil) then return end
	local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:IsCode(53796217) and c:GetSequence()<5 and c:IsStatus(STATUS_EFFECT_ENABLED)end,tp,LOCATION_SZONE,0,nil)
	if #g==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp):GetFirst()
		if tc then Duel.HintSelection(Group.FromCards(tc)) s.act(e,tp,Group.FromCards(tc)) end
	else
		local tc=SNNM.Select_1(g,tp,HINTMSG_FACEUP)
		local s1,s2=e:GetHandler():GetSequence(),tc:GetSequence()
		local sg=Duel.GetMatchingGroup(function(c)return c:GetSequence()>math.min(s1,s2) and c:GetSequence()<math.max(s1,s2)end,tp,LOCATION_SZONE,0,nil,s1,s2):Filter(s.filter,nil,e,tp)
		if tc then s.act(e,tp,sg) end
	end
end
function s.act(e,tp,g)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		if tc:GetFlagEffect(id+500)==0 then
			tc:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1)
			local le={tc:GetActivateEffect()}
			for _,v in pairs(le) do
				if v:GetCode()==EVENT_FREE_CHAIN then
					local e1=v:Clone()
					e1:SetType(EFFECT_TYPE_QUICK_F)
					e1:SetCode(EVENT_CUSTOM+id)
					e1:SetRange(LOCATION_SZONE)
					local pro1,pro2=v:GetProperty()
					e1:SetProperty(pro1|EFFECT_FLAG_SET_AVAILABLE,pro2)
					local con=v:GetCondition() or aux.TRUE
					e1:SetCondition(s.con(con))
					e1:SetCountLimit(1)
					tc:RegisterEffect(e1)
					local e1_1,e2,e3,e2_1=SNNM.ActivatedAsSpellorTrap(tc,tc:GetOriginalType(),LOCATION_SZONE,true,e1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
				end
			end
		end
	end
	Duel.AdjustAll()
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,tp,tp,0)
	g:ForEach(Card.ResetFlagEffect,id)
end
function s.con(con)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsFacedown() and e:GetHandler():GetFlagEffect(id)>0 and con
	end
end
