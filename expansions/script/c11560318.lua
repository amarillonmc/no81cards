--永劫的吸血鬼·亚瑞扎特
function c11560318.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11560318.mfilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckAsCost,LOCATION_MZONE,0,Duel.SendtoDeck,nil,2,REASON_COST+REASON_MATERIAL) 
	--splimit
	--local e0=Effect.CreateEffect(c)
	--e0:SetType(EFFECT_TYPE_SINGLE)
	--e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e0:SetCode(EFFECT_SPSUMMON_CONDITION) 
	--e0:SetCondition(function(e) 
	--return e:GetHandler():IsLocation(LOCATION_EXTRA) end) 
	--c:RegisterEffect(e0)
	--redirect 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)	 
	--atk and des
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,11560318)
	e1:SetTarget(c11560318.adestg) 
	e1:SetOperation(c11560318.adesop) 
	c:RegisterEffect(e1) 
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e2:SetValue(function(e,c)
	return c~=e:GetHandler() end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)  
	c:RegisterEffect(e2)
	--special summon
	--local e3=Effect.CreateEffect(c) 
	--e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	--e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetCode(EVENT_REMOVE)
	--e3:SetCountLimit(1,21560318)
	--e3:SetCondition(c11560318.regcon)
	--e3:SetOperation(c11560318.regop)
	--c:RegisterEffect(e3)
	--special summon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,21560318)
	e3:SetOperation(c11560318.regop2)
	c:RegisterEffect(e3)
	if not c11560318.global_check then
		c11560318.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c11560318.rmckop)
		Duel.RegisterEffect(ge1,0) 
	end 
end
c11560318.SetCard_XdMcy=true  
function c11560318.regop2(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end

		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c11560318.retcon)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetOperation(c11560318.spop2)
		Duel.RegisterEffect(e1,tp)
end 
function c11560318.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c11560318.spfilter2(c,e,tp)
	return c:IsCode(11560318) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c11560318.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c11560318.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
		Duel.Hint(HINT_CARD,0,11560318) 
		local g=Duel.SelectMatchingCard(tp,c11560318.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()  
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP) 
		e:Reset()
	end 
end
function c11560318.mfilter(c) 
	return c.SetCard_XdMcy  
end 
function c11560318.rmckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst() 
	while tc do   
	local flag=Duel.GetFlagEffectLabel(tc:GetControler(),11560318)
	if flag==nil then 
	Duel.RegisterFlagEffect(tc:GetControler(),11560318,0,0,0,1) 
	else 
	Duel.SetFlagEffectLabel(tc:GetControler(),11560318,flag+1)   
	end 
	tc=eg:GetNext() 
	end 
end  
function c11560318.adestg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,11560318) 
	if chk==0 then return flag and flag>=10 end 
end 
function c11560318.adesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1600)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e2) 
	Duel.Damage(1-tp,800,REASON_EFFECT) 
	end 
end 
function c11560318.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c11560318.regop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e1:SetRange(LOCATION_REMOVED) 
	e1:SetLabelObject(c)
	e1:SetCountLimit(1)  
	e1:SetOperation(c11560318.spop)
	e1:SetLabel(0) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
end 
function c11560318.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject() 
	local x=e:GetLabel() 
	x=x+1 
	e:SetLabel(x) 
	c:SetTurnCounter(x) 
	if x==1 then 
		Duel.Hint(HINT_CARD,0,11560318)   
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		e:Reset()
	end 
end









