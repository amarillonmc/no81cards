--雷蛇·瑟谣浮收藏-阴天快乐
function c79029914.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79029914.ffilter,2,false)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029043)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79029914.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c79029914.sprcon)
	e2:SetOperation(c79029914.sprop)
	c:RegisterEffect(e2)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,79029914)
	e3:SetTarget(c79029914.xxtg)
	e3:SetOperation(c79029914.xxop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(79029914,ACTIVITY_CHAIN,c79029914.chainfilter)
end
function c79029914.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsType(TYPE_TRAP) and rc:IsSetCard(0x1904))
end
function c79029914.ffilter(c)
	return c:IsLevelAbove(7) and c:IsSetCard(0x1904)
end
function c79029914.spcfilter(c)
	return c:IsLevelAbove(7) and c:IsSetCard(0x1904) and c:IsAbleToGraveAsCost()
end
function c79029914.mzfilter(c)
	return c:GetSequence()<5 or not c:IsLocation(LOCATION_MZONE)
end
function c79029914.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c79029914.spcfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and mg:GetCount()>1 and (ft>0 or mg:IsExists(c79029914.mzfilter,ct,nil)) and Duel.GetCustomActivityCount(79029914,tp,ACTIVITY_CHAIN)~=0
end
function c79029914.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c79029914.spcfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=mg:Select(tp,2,2,nil)
	elseif ft>-1 then
		local ct=-ft+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=mg:FilterSelect(tp,c79029914.mzfilter,ct,ct,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=mg:Select(tp,2-ct,2-ct,g)
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=mg:FilterSelect(tp,c79029914.mzfilter,2,2,nil)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
	c:SetMaterial(g)
	Debug.Message("雷蛇，准备完毕。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029914,0))
end
function c79029914.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.GetCustomActivityCount(79029914,sp,ACTIVITY_CHAIN)~=0
end
function c79029914.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local x=Duel.GetCustomActivityCount(79029914,tp,ACTIVITY_CHAIN)
	if chk==0 then return x>0 and Duel.IsPlayerCanDiscardDeck(tp,x) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,x,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c79029914.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=Duel.GetCustomActivityCount(79029914,tp,ACTIVITY_CHAIN)
	local g=Duel.GetDecktopGroup(tp,x)
	if g then 
	local x=Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Recover(tp,x*1000,REASON_EFFECT)
	Debug.Message("时刻准备。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029914,1))
	end
end



