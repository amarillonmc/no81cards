--动物朋友 团三郎狸
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700086.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(33700086,0))
	Senya.AddAttackSE(c,aux.Stringid(33700086,1))
	 --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	 --copy
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(33700086)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(33710086)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c33700086.op)
	c:RegisterEffect(e2)
	c33700086[e2]={}
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetCondition(c33700086.adcon)
	e2:SetValue(3200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(3200)
	c:RegisterEffect(e3)
end
function c33700086.copyfilter(c,ec)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
	return c:IsSetCard(0x442) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsHasEffect(33700086) and g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700086.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function c33700086.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(c33700086.gfilter2,1,nil,c:GetOriginalCode())
end
function c33700086.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function c33700086.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=c33700086[e]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetMatchingGroup(c33700086.copyfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local dg=exg:Filter(c33700086.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(c33700086.gfilter1,nil,exg)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		e:SetCondition(c33700086.rcon(e:GetCondition(),tc,copyt))
		f(tc,e,forced)
	end
	for tc in aux.Next(cg) do
		copyt[tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
	Card.RegisterEffect=f
end
function c33700086.rcon(con,tc,copyt)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsHasEffect(33710086) then
			c:ResetEffect(c,copyt[tc],RESET_COPY)
			copyt[tc]=nil
			return false
		end
		return not con or con(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33700086.cfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function c33700086.adcon(e)
	 return not Duel.IsExistingMatchingCard(c33700086.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
