--闪刀姬 宙翼
function c11513053.initial_effect(c) 
	c:SetSPSummonOnce(11513053)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c11513053.lcheck)
	c:EnableReviveLimit() 
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(0xff)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(c11513053.atkval) 
	e1:SetCondition(c11513053.atkcon) 
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval) 
	e2:SetCondition(c11513053.idcon)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	e3:SetCondition(c11513053.idcon)
	c:RegisterEffect(e3)
	if not c11513053.global_check then
		c11513053.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS) 
		ge1:SetLabelObject(e1) 
		ge1:SetOperation(c11513053.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0) 
		local g=Group.CreateGroup() 
		g:KeepAlive() 
		ge1:GetLabelObject():SetLabelObject(g)
	end
end
function c11513053.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		local te=e:GetLabelObject() 
		local xg=te:GetLabelObject() 
		if tc:IsSetCard(0x1115) and not xg:IsExists(Card.IsCode,1,nil,tc:GetCode()) then 
			xg:AddCard(tc)   
		end 
		tc=eg:GetNext() 
	end
end
function c11513053.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1115) 
end 
function c11513053.atkval(e)  
	local g=e:GetLabelObject()
	return g and g:GetClassCount(Card.GetCode)*600   
end 
function c11513053.atkcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroup(function(c) return c:IsSetCard(0x1115) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=3
end 
function c11513053.idcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
end 
















