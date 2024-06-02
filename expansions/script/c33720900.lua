--[[
Ruler Cell - 统领细胞怪
Ruler Cell
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Banish cards from your opponent's GY until there are no cards with the same name in their GY, also Special Summon this card as an Effect Monster (Fiend/DARK/Level 10/ATK 3000/DEF 2500).(This card is also still a Trap.)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--[[If Summoned this way, this card cannot be destroyed by battle or card effects, also all battle damage you would take becomes 0 while your opponent has less than 27 cards with different names in their GY.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.ProcSummonedCond)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.damcon)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	--While this card is in the Monster Zone, if there are no cards with the same name in your GY, send this card to the GY.
	local e6=Effect.CreateEffect(c)
	e6:Desc(1,id)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_SELF_TOGRAVE)
	e6:SetCondition(s.sdcon)
	c:RegisterEffect(e6)
end
--E1
function s.hascopy(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function s.namecheck(g)
	local c1,c2=g:GetFirst(),g:GetNext()
	return c1:IsCode(c2:GetCode())
end
function s.gcheck(og)
	return	function(g,e,tp,mg,c)
				for tc in aux.Next(og) do
					local codes={tc:GetCode()}
					for _,code in ipairs(codes) do
						local ct=g:FilterCount(Card.IsCode,nil,code)
						local ct1=og:FilterCount(Card.IsCode,nil,code)
						if ct~=ct1-1 then
							return false,ct>ct1-1
						end
					end
				end
				local cg=og:Clone()
				cg:Sub(g)
				local res=cg:CheckSubGroup(s.namecheck,2,2)
				return not res, not c:IsAbleToRemove()
			end
end
function s.finishcon(og)
	return	function(g,e,tp,mg)
				for tc in aux.Next(og) do
					local codes={tc:GetCode()}
					for _,code in ipairs(codes) do
						local ct=g:FilterCount(Card.IsCode,nil,code)
						local ct1=og:FilterCount(Card.IsCode,nil,code)
						if ct~=ct1-1 then
							return false
						end
					end
				end
				local cg=og:Clone()
				cg:Sub(g)
				local res=cg:CheckSubGroup(s.namecheck,2,2)
				return not res
			end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not (e:IsCostChecked()
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,3000,2500,10,RACE_FIEND,ATTRIBUTE_DARK)) then
			return false
		end
		local gy=Duel.GetGY(1-tp)
		local g=gy:Filter(s.hascopy,nil,gy)
		if #g==0 then return false end
		return aux.SelectUnselectGroup(g,e,tp,1,#g-1,s.gcheck(g),0)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local gy=Duel.GetGY(1-tp)
	local g=gy:Filter(s.hascopy,nil,gy)
	if #g>0 then
		local rg=aux.SelectUnselectGroup(g,e,tp,1,#g-1,s.gcheck(g),1,tp,HINTMSG_REMOVE,s.finishcon(g))
		if #rg>0 then
			Duel.HintSelection(rg)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,3000,2500,10,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end

--E2
function s.damcon(e)
	if not aux.ProcSummonedCond(e) then return false end
	local tp=e:GetHandlerPlayer()
	local og=Duel.GetGY(1-tp)
	return og:GetClassCount(Card.GetCode)<27
end

--E6
function s.sgcheck(g)
	local c1,c2=g:GetFirst(),g:GetNext()
	return c1:IsCode(c2:GetCode())
end
function s.sdcon(e)
	if not aux.ProcSummonedCond(e) then return false end
	local tp=e:GetHandlerPlayer()
	local sg=Duel.GetGY(tp)
	return not sg:CheckSubGroup(s.sgcheck,2,2)
end