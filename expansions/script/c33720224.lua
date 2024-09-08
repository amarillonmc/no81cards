--[[
薮胞
Cellval
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[This card's name becomes "Anifriends Cellval" while on the field or in the GY.]]
	aux.EnableChangeCode(c,CARD_ANIFRIENDS_CELLVAL,LOCATION_ONFIELD|LOCATION_GRAVE)
	--[[When an opponent's monster declares a direct attack: Banish as few cards as possible from your GY, until there are no cards with the same name in your GY,
	also Special Summon this card as an Effect Monster (Fairy/LIGHT/Level 4/ATK 1600/DEF 1700).(This card is also still a Trap.) If Summoned this way, this card gains 200 ATK for
	each card banished by its effect.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetFunctions(s.condition,nil,s.target,s.activate)
	c:RegisterEffect(e1)
	--[[While you have 20 or more cards in your GY, this card is unaffected by other card effects, also it cannot be destroyed by battle.]]
	c:Unaffected(UNAFFECTED_OTHER,s.pccon,nil,c,LOCATION_MZONE)
	c:CannotBeDestroyedByBattle(1,s.pccon,nil,c,LOCATION_MZONE)
	--If this card in a Monster Zone has 3000 or more ATK (Quick Effect): You can Tribute this card; Special Summon 1 "Anifriends Cellval" from your Extra Deck, ignoring its Summoning conditions.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetRelevantTimings()
	e2:SetFunctions(s.spcon,aux.TributeSelfCost,s.sptg,s.spop)
	c:RegisterEffect(e2)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function s.rmfilter(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function s.rescon(og)
	return	function(g,e,tp,mg,c)
				local cg=og:Filter(aux.TRUE,g)
				if c and not cg:IsExists(Card.IsCode,1,nil,c:GetCode()) then
					return false,true
				end
				return true
			end
end
function s.finishcon(ct,og)
	return	function(g,e,tp,mg)
				local cg=og:Filter(aux.TRUE,g)
				local dnct=g:GetClassCount(Card.GetCode)
				local cdnct=cg:GetClassCount(Card.GetCode)
				return dnct==ct and cdnct==ct
			end
end
function s.hasSameCodeButNotOtherOnes(c,code)
	local codes={c:GetCode()}
	if #codes>1 then return false end
	return codes[1]==code
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not (e:IsCostChecked()
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,1600,1700,4,RACE_FAIRY,ATTRIBUTE_LIGHT)) then
			return false
		end
		local gy=Duel.GetGY(tp)
		local g=gy:Filter(s.rmfilter,nil,gy)
		local ct=#g
		if ct<=0 then return false end
		local tc=g:GetFirst()
		while tc do
			local sg=g:Filter(s.hasSameCodeButNotOtherOnes,nil,tc:GetCode())
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			end
			local nrg=sg:Filter(aux.NOT(Card.IsAbleToRemove),nil)
			if #nrg>0 then
				if #nrg>=2 then
					return false
				end
				g:Sub(nrg)
				tc=g:GetFirst()
			else
				tc=g:GetNext()
			end
		end
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=true
	local gy=Duel.GetGY(tp)
	local g=gy:Filter(s.rmfilter,nil,gy)
	local ct=#g
	if ct<=0 then b1=false end
	if b1 then
		local tc=g:GetFirst()
		while tc do
			local sg=g:Filter(s.hasSameCodeButNotOtherOnes,nil,tc:GetCode())
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			end
			local nrg=sg:Filter(aux.NOT(Card.IsAbleToRemove),nil)
			if #nrg>0 then
				if #nrg>=2 then
					b1=false
					break
				end
				g:Sub(nrg)
				tc=g:GetFirst()
			else
				tc=g:GetNext()
			end
		end
	end
	local rmct=0
	if b1 and #g>0 then
		local dnct=g:GetClassCount(Card.GetCode)
		local rescon=s.rescon(g)
		local rg=aux.SelectUnselectGroup(g,e,tp,ct-dnct,ct-1,rescon,1,tp,HINTMSG_REMOVE,s.finishcon(dnct,g))
		if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
			rmct=Duel.GetGroupOperatedByThisEffect(e):GetCount()
		end
	end
	
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,1600,1700,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 and rmct>0 then
		c:UpdateATK(rmct*200,true,c)
	end
end

--protection
function s.pccon(e)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetGYCount(tp)
	return ct>=20
end

--E2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(3000)
end
function s.spfilter(c,e,tp,exc)
	return c:IsCode(CARD_ANIFRIENDS_CELLVAL) and Duel.GetLocationCountFromEx(tp,tp,exc,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local exc=e:IsCostChecked() and c or nil
		return Duel.IsExists(false,s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,exc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end