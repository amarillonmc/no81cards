local m=82224081
local cm=_G["c"..m]
cm.name="四九圣尊"
function cm.initial_effect(c)
	c:EnableReviveLimit()  
	--connot special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e1) 
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetCountLimit(1,m)  
	e2:SetCost(cm.spcost)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
	--act limit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(0,1)  
	e3:SetValue(cm.aclimit)  
	c:RegisterEffect(e3)  
end
function cm.rfilter(c,tp)  
	return c:GetOriginalLevel()>0 and (c:IsControler(tp) or c:IsFaceup())  
end  
function cm.fselect(g,tp)  
	Duel.SetSelectedCard(g)  
	return g:CheckWithSumGreater(Card.GetOriginalLevel,49) and aux.mzctcheckrel(g,tp)  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil,tp)  
	if chk==0 then return g:CheckSubGroup(cm.fselect,1,g:GetCount(),tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)  
	local rg=g:SelectSubGroup(tp,cm.fselect,false,1,g:GetCount(),tp)  
	Duel.Release(rg,REASON_COST)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4399)
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		Duel.Damage(1-tp,4399,REASON_EFFECT)
	end  
end  
function cm.aclimit(e,re,tp)  
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetLevel()<=e:GetHandler():GetLevel() 
end  