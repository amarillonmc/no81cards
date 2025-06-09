--右方之火
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,5012604,s.sfliter,2,true,true)
	--special summon rule
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_EXTRA)
	e10:SetCondition(s.hspcon)
	e10:SetTarget(s.hsptg)
	e10:SetOperation(s.hspop)
	c:RegisterEffect(e10)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.damcost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(s.adcon)
	e3:SetOperation(s.adop)
	c:RegisterEffect(e3)
end
function s.sfliter(c)
	return c.MoJin==true 
end
function s.cfilter(c,mc)
	return ((c.MoJin==true and c:IsLocation(LOCATION_MZONE)) or c:IsFusionCode(5012604)) 
		and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(mc)
			and c:IsFusionType(TYPE_MONSTER)
end
function s.fselect(g,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,g,mc)>0
		and g:IsExists(Card.IsFusionCode,1,nil,5012604) and g:IsExists(Card.IsFusionSetCard,2,nil,MoJin==true)
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c.cfilter,tp,LOCATION_ONFIELD,0,nil,c)
	return g:CheckSubGroup(s.fselect,3,3,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,s.fselect,false,3,3,tp,c)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	return true
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
	g:DeleteGroup()
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_COST+REASON_RELEASE)
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.efilter(e,re)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_SPELL) or (rc:IsType(TYPE_MONSTER) and rc:GetBaseAttack()<=3800)
end
function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup() and (bc:IsAttackAbove(1700) or bc:IsDefenseAbove(800))
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=bc:GetAttack()
	local def=bc:GetDefense()
	local dam=atk 
	if atk<def then dam=def end
	if c:IsFaceup() and Duel.SendtoDeck(bc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and dam>0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end