--区域掌握者
function c10173090.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()   
	--move 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173090,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10173090)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10173090.mvtg)
	e1:SetOperation(c10173090.mvop)
	c:RegisterEffect(e1) 
	--move 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173090,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10173190)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c10173090.mvtg2)
	e2:SetOperation(c10173090.mvop2)
	c:RegisterEffect(e2) 
end
function c10173090.filter(c,e)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,c:GetControler(),LOCATION_REASON_CONTROL)>0 and c:IsCanBeEffectTarget(e)
end
function c10173090.mvtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return lg:IsContains(chkc) and c10173090.filter(chkc,e) end
	if chk==0 then return lg:IsExists(c10173090.filter,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=lg:FilterSelect(tp,c10173090.filter,1,1,nil,e)
	Duel.SetTargetCard(g)
end
function c10173090.mvop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=0
	if tc:IsControler(tp) then
	   s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	else
	   s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)/0x10000
	end
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c10173090.cfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsControler(tp)
end
function c10173090.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return false end
	if chk==0 then return lg:IsExists(c10173090.cfilter,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=lg:FilterSelect(tp,c10173090.cfilter,2,2,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c10173090.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsControler,nil,tp)
	if g:GetCount()~=2 then return end
	Duel.SwapSequence(g:GetFirst(),g:GetNext())
end

