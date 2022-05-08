--暗黑界的邪神 布鲁德
function c26699730.initial_effect(c)
	c:SetSPSummonOnce(8491308)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c26699730.lcheck)
	c:EnableReviveLimit()
	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(26699730)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0xff)
	e2:SetOperation(c26699730.adjustop)
	c:RegisterEffect(e2)
end
function c26699730.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c26699730.globle_check then
		c26699730.globle_check=true
		local g=Duel.GetMatchingGroup(c26699730.filter,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		local Infernoid_check=false
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetCode()~=EFFECT_SPSUMMON_PROC then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			if effect and effect:GetCode()==EFFECT_SPSUMMON_PROC then
				Infernoid_check=true
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			Infernoid_check=false
			tc:ReplaceEffect(34822855,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
			if Infernoid_check then 
				--special summon
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_SPSUMMON_PROC)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2:SetCondition(c26699730.spcon)
				e2:SetTarget(c26699730.sptg)
				e2:SetOperation(c26699730.spop)
				if tc:IsLevelBelow(4) then
					e2:SetRange(LOCATION_HAND)
					e2:SetLabel(1)
				elseif tc:IsLevelAbove(5) and tc:IsLevelBelow(8) then
					e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
					e2:SetLabel(2)
				else
					e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
					e2:SetLabel(3)
				end
				cregister(tc,e2)
				local e3=e2:Clone()
				e3:SetCondition(c26699730.spcon2)
				e3:SetTarget(c26699730.sptg2)
				e3:SetOperation(c26699730.spop2)
				cregister(tc,e3)
			end
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
function c26699730.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xbb)
end
function c26699730.filter(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SPSUMMON) 
end
function c26699730.sumfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c26699730.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function c26699730.spfilter(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c26699730.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,26699730) then return false end
	local sum=Duel.GetMatchingGroup(c26699730.sumfilter,tp,LOCATION_MZONE,0,nil):GetSum(c26699730.lv_or_rk)
	if sum>8 then return false end
	local loc=LOCATION_GRAVE+LOCATION_HAND
	if c:IsHasEffect(34822850) then loc=loc+LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c26699730.spfilter,tp,loc,0,c)
	return g:CheckSubGroup(aux.mzctcheck,e:GetLabel(),e:GetLabel(),tp)
end
function c26699730.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local loc=LOCATION_GRAVE+LOCATION_HAND
	if c:IsHasEffect(34822850) then loc=loc+LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c26699730.spfilter,tp,loc,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,e:GetLabel(),e:GetLabel(),tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c26699730.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function c26699730.spfilter2(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER)
end
function c26699730.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsPlayerAffectedByEffect(tp,26699730) then return false end
	local sum=Duel.GetMatchingGroup(c26699730.sumfilter,tp,LOCATION_MZONE,0,nil):GetSum(c26699730.lv_or_rk)
	if sum>8 then return false end
	local g=Duel.GetMatchingGroup(c26699730.spfilter2,tp,LOCATION_REMOVED,0,c)
	return g:CheckSubGroup(aux.mzctcheck,e:GetLabel(),e:GetLabel(),tp)
end
function c26699730.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c26699730.spfilter2,tp,LOCATION_REMOVED,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,e:GetLabel(),e:GetLabel(),tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c26699730.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
	g:DeleteGroup()
end

