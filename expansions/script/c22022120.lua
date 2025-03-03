--人子啊，紧系神明吧！
function c22022120.initial_effect(c)
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22022120,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,22022120+EFFECT_COUNT_CODE_DUEL)
	e0:SetCondition(c22022120.con)
	e0:SetTarget(c22022120.tg)
	e0:SetOperation(c22022120.op)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022120,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c22022120.damtg)
	e1:SetOperation(c22022120.damop)
	c:RegisterEffect(e1)
end
function c22022120.xyzfilter(c,e)
	return c:GetEquipCount()>0 and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,22022070) and c:IsCanBeXyzMaterial(e:GetHandler()) and Duel.GetMZoneCount(c:GetControler(),c,c:GetControler())>0
end
function c22022120.con(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c22022120.xyzfilter,c:GetControler(),0,LOCATION_MZONE,1,nil,e)
end
function c22022120.tg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=Duel.GetMatchingGroup(c22022120.xyzfilter,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Duel.SelectOption(tp,aux.Stringid(22022120,2))
		Duel.SelectOption(tp,aux.Stringid(22022120,3))
		local xg=g:Select(tp,1,1,nil)
		xg:KeepAlive()
		e:SetLabelObject(xg)
	return true
	else return false end
end
function c22022120.op(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		Duel.SendtoGrave(mg2,REASON_RULE)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c22022120.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
	Duel.SelectOption(tp,aux.Stringid(22022120,4))
end
function c22022120.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.SelectOption(tp,aux.Stringid(22022120,5))
	Duel.Damage(p,d,REASON_EFFECT)
end