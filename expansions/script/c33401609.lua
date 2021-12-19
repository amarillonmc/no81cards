--涤罪之观测者 万由里
local m=33401609
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
XY.mayuri(c)
	  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true) 
--
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,m)
	e7:SetTarget(cm.destg)
	e7:SetOperation(cm.desop)
	c:RegisterEffect(e7)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x341) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

function cm.ckfilter(c,tp)
	return  (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and Duel.IsExistingMatchingCard(cm.ckfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function cm.ckfilter2(c,at)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)   and  c:GetAttribute()&at~=0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and cm.ckfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.ckfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.ckfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	 local tc=g:GetFirst()
	local tg=Duel.GetMatchingGroup(cm.ckfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	 Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tg:GetCount()*500) 
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,0,0,0) 
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) and Duel.IsExistingMatchingCard(cm.ckfilter2,tp,0,LOCATION_MZONE,1,nil,tc:GetAttribute())  then 
		local g=Duel.GetMatchingGroup(cm.ckfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		local ss=Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(1-tp,ss*500,REASON_EFFECT)
	end
end


