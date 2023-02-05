--屠戮生将军 阿罗娑迦鬼
function c87498096.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c87498096.spcon)
	e1:SetTarget(c87498096.sptg)
	e1:SetOperation(c87498096.spop)
	c:RegisterEffect(e1) 
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(c87498096.atlimit)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetValue(c87498096.efilter)
	c:RegisterEffect(e1) 
	--ANNOUNCE 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_ANNOUNCE) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)
	e2:SetTarget(c87498096.antg) 
	e2:SetOperation(c87498096.anop) 
	c:RegisterEffect(e2) 
end
function c87498096.spfilter(c)
	return c:IsReleasable() 
end
function c87498096.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c87498096.spfilter,tp,LOCATION_MZONE,0,nil)
	return mg:CheckSubGroup(aux.mzctcheck,3,3,tp)
end
function c87498096.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c87498096.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,aux.mzctcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c87498096.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function c87498096.atlimit(e,c) 
	local seq1=e:GetHandler():GetSequence()
	local seq2=c:GetSequence()  
	if seq1==0 then return seq2~=4 
	elseif seq1==1 then return seq2~=3 and seq2~=5 
	elseif seq1==2 then return seq2~=2 
	elseif seq1==3 then return seq2~=1 and seq2~=6 
	elseif seq1==4 then return seq2~=0   
	elseif seq1==5 then return seq2~=3 
	elseif seq1==6 then return seq2~=1 
	else return false end  
end
function c87498096.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end 
	if not te:GetHandler():IsOnField() then return true end 
	local seq1=e:GetHandler():GetSequence()
	local seq2=te:GetHandler():GetSequence()  
	if seq1==0 then return seq2~=4 
	elseif seq1==1 then return seq2~=3 and seq2~=5 
	elseif seq1==2 then return seq2~=2 
	elseif seq1==3 then return seq2~=1 and seq2~=6 
	elseif seq1==4 then return seq2~=0   
	elseif seq1==5 then return seq2~=3 
	elseif seq1==6 then return seq2~=1 
	else return false end   
end
function c87498096.antg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler() 
	if chk==0 then return true end 
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(att) 
	if att==ATTRIBUTE_DARK then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498096,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(17498096) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif att==ATTRIBUTE_EARTH then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498096,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(27498096)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif att==ATTRIBUTE_FIRE then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498096,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(37498096)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif att==ATTRIBUTE_LIGHT then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498096,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(47498096)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif att==ATTRIBUTE_WATER then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498096,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(57498096)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif att==ATTRIBUTE_WIND then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498096,6))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(67498096)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif att==ATTRIBUTE_DIVINE then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(87498096,7))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77498096)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end  
	if Duel.IsPlayerAffectedByEffect(tp,17498096) 
	and Duel.IsPlayerAffectedByEffect(tp,27498096)
	and Duel.IsPlayerAffectedByEffect(tp,37498096)
	and Duel.IsPlayerAffectedByEffect(tp,47498096)
	and Duel.IsPlayerAffectedByEffect(tp,57498096)
	and Duel.IsPlayerAffectedByEffect(tp,67498096)
	and Duel.IsPlayerAffectedByEffect(tp,77498096) then 
		Duel.Win(tp,0x1) 
	end 
end 
function c87498096.anop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local att=e:GetLabel() 
	if att and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_CANNOT_TRIGGER)  
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,0xff) 
		e1:SetTarget(function(e,c) 
		return c:IsAttribute(att) and not c:IsLocation(LOCATION_GRAVE) end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_FIELD) 
		e2:SetCode(EFFECT_DISABLE)  
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,0xff) 
		e2:SetTarget(function(e,c) 
		return c:IsAttribute(att) and not c:IsLocation(LOCATION_GRAVE) end) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION) 
		e1:SetValue(function(e,se,sp,st)  
		return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end) 
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_GRAVE)
		e2:SetTarget(function(e,c) 
		return c:IsAttribute(att) end)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e2)
	end 
end 









