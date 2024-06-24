if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(s.scop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s[0]={}
		local f=Duel.Summon
		Duel.Summon=function(sp,sc,...)
			s[0][sc]=sc:GetFieldID()
			return f(sp,sc,...)
		end
	end
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if s[0][c] and s[0][c]==c:GetFieldID() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.sumop)
	e1:SetReset(RESET_EVENT+0x4fe0000)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and not c:CheckActivateEffect(false,true,false)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	local le={tc:GetActivateEffect()}
	for i,v in pairs(le) do
		if v:GetRange()&0x10a~=0 then
			local e1=v:Clone()
			e1:SetRange(LOCATION_REMOVED)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			local e2=SNNM.Act(tc,e1)
			e2:SetRange(LOCATION_REMOVED)
			e2:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
		end
	end
end
