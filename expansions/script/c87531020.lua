--静点星-月相完满
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER),76,true)
	--特召条件
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--特召规则
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)    
	--放置额外    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(s.excon)
	e2:SetOperation(s.exop)
	c:RegisterEffect(e2)
	--特召或送墓    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)        
end
function s.sprfilter(c,sc)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and c:IsAbleToGraveAsCost()
end
function s.sprcon(e,c)
	if c==nil then return true end
    local g=Duel.GetMatchingGroup(s.sprfilter,c:GetControler(),LOCATION_HAND,0,nil,c)
	return g:GetCount()>0 and c:IsFacedown() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_HAND,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.SendtoGrave(tc,REASON_SPSUMMON)
    e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
end
function s.excon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsFaceup()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
    if tc:IsType(TYPE_TUNER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
    	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)        	        
    else    
        Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end