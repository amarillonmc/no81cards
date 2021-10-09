--新年的英灵·武藏
function c9981470.initial_effect(c)
		 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),2,2)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c9981470.lmlimit)
	c:RegisterEffect(e1)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(2)
	c:RegisterEffect(e4)
 --to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981470,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c9981470.tgtg)
	e4:SetOperation(c9981470.tgop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981470.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981470.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9981470,0))
end
function c9981470.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c9981470.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:GetSummonLocation()==LOCATION_EXTRA end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function c9981470.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,1000,REASON_EFFECT)~=0 then
		local d=Duel.GetAttackTarget()
		if d:IsRelateToBattle() and d:GetSummonLocation()==LOCATION_EXTRA then
			Duel.SendtoGrave(d,REASON_EFFECT)
		end
	end
   Duel.Hint(HINT_MUISC,0,aux.Stringid(9981470,1))
   Duel.Hint(HINT_SOUND,0,aux.Stringid(9981470,2))
end