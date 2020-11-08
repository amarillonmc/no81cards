--可颂·KFC收藏-清晨七点
function c79029297.initial_effect(c)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029053)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetCondition(c79029297.sprcon)
	e1:SetOperation(c79029297.sprop)
	c:RegisterEffect(e1)	
	--defense attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DEFENSE_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c79029297.cttg)
	e1:SetOperation(c79029297.ctop)
	c:RegisterEffect(e1)	   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c79029297.ovtg)
	e1:SetOperation(c79029297.ovop)
	c:RegisterEffect(e1)	 
end
function c79029297.sprfilter(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsFaceup() and (lv==9  or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_SZONE))) and (Duel.GetLocationCountFromEx(tp,tp,c)>0 or Duel.GetMZoneCount(tp,c)>0)
end
function c79029297.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79029297.sprfilter,tp,LOCATION_ONFIELD,0,3,nil)
end
function c79029297.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029297.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:Select(tp,3,3,nil)
	e:GetHandler():SetMaterial(g1)
	Duel.Overlay(e:GetHandler(),g1)
	Debug.Message("让我试试新装备吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029297,6))
end
function c79029297.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c79029297.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029297.posfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetTurnPlayer()~=tp end
	local g=Duel.GetMatchingGroup(c79029297.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c79029297.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(c79029297.posfilter,tp,0,LOCATION_MZONE,nil)
	if g2:GetCount()>0 then
	Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
	Debug.Message("停下！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029297,2))
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029297,0)) then
	g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Overlay(e:GetHandler(),g)
	Debug.Message("敌人有没有掉落宝箱什么的呢？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029297,3))
	end
	end
end
function c79029297.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetTurnPlayer()==tp end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetTargetCard(g)
end
function c79029297.ovop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Overlay(e:GetHandler(),g)
	Debug.Message("这里有没有宝箱？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029297,4))
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,e:GetHandler(),TYPE_XYZ) and e:GetHandler():GetOverlayCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(79029297,1)) then
	local og=e:GetHandler():GetOverlayGroup()
	local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),TYPE_XYZ):GetFirst()
	local vg=og:Select(tp,1,og:GetCount(),nil)
	Duel.Overlay(tc,vg)
	Debug.Message("大家！让我们漂漂亮亮地完成这次工作吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029297,5))
	end
end

 



