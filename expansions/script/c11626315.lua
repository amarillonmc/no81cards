--隐匿虫 疗愈虫

local s,id,o=GetID()
local zd=0x3220

function s.initial_effect(c)
	--LkSum
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.lkfilter,1,1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) return not c:IsSetCard(zd) end)
	c:RegisterEffect(e1)
	--AtkUpAndRecover
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_DRAW) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.recatkcon)
	e2:SetOperation(s.recatkop) 
	c:RegisterEffect(e2) 
end 

function s.lkfilter(c)
	return c:IsLinkRace(RACE_INSECT) and c:IsLevelAbove(1)
end

function s.recatkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)  
end
function s.recatkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if ep~=tp and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_CARD,0,id) 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
		local tc=g:GetFirst()  
		while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(ev*200) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)
			tc=g:GetNext() 
		end 
		Duel.Recover(tp,ev*200,REASON_EFFECT) 
	end 
end 