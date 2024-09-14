--大瘟疫
local cm,m,o=GetID()
function cm.initial_effect(c)
 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE) --要用 EFFECT_CANNOT_ACTIVATE
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(0,1)
	e0:SetCondition(cm.atkcon)
	e0:SetValue(cm.desfilther2) --直接使用 cm.desfilther1 即可
	c:RegisterEffect(e0)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)  
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(cm.atkval2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(cm.imcon)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)	
end
function cm.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function cm.desfilther2(e,re,tp) --写反了，第一个参数是效果，第二个是卡
	local seq=e:GetHandler():GetSequence()
	local sseq=re:GetHandler():GetSequence()
	if not re:GetHandler():IsLocation(LOCATION_ONFIELD) then
		return false
	end
	return (seq<5 and sseq<5 and math.abs(4-sseq-seq)<=1) or (seq<5 and sseq==5 and seq>1) or (seq<3 and sseq==6) or (seq==6 and sseq<3) or (seq==5 and sseq>1 and sseq<5)
end
function cm.desfilther1(e,c) --写反了，第一个参数是效果，第二个是卡
	local seq=c:GetSequence()
	local sseq=e:GetHandler():GetSequence()
	return (seq<5 and sseq<5 and math.abs(4-sseq-seq)<=1) or (seq<5 and sseq==5 and seq>1) or (seq<3 and sseq==6) or (seq==6 and sseq<3) or (seq==5 and sseq>1 and sseq<5)
end
function cm.dlfilter(c,tp)
	return c:IsControler(1-tp)
end
function cm.aclimit(e,c)
	local tp=e:GetHandler():GetControler()
	local cg3=Duel.GetMatchingGroup(cm.desfilther1,tp,0,LOCATION_ONFIELD,nil,e)
	return cg3:IsExists(cm.dlfilter,1,nil,e:GetHandlerPlayer()) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function cm.imcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.atkval(e)
	return Duel.GetMatchingGroupCount(nil,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)*-500
end
function cm.atkval2(e)
	return Duel.GetMatchingGroupCount(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-500
end
function cm.filter(c)
	return c:IsAttack(0)
end
