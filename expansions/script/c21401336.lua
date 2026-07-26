--熔岩谷大日桑派
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--超量召唤：
	--4星「熔岩」或「大日」怪兽×2
	--也可以使用自己场上表侧的「熔岩」魔法·陷阱卡作为4星怪兽
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(
		EFFECT_FLAG_CANNOT_DISABLE
		+EFFECT_FLAG_UNCOPYABLE
	)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.xyzcon)
	e0:SetTarget(s.xyztg)
	e0:SetOperation(s.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--①：取除2个超量素材，特殊召唤「熔岩」与「大日」怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--②：结束阶段将对象怪兽作为装备卡装备
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+2)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	--③：场上·墓地的这张卡成为效果对象时检索
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e3:SetProperty(
		EFFECT_FLAG_DAMAGE_STEP
		+EFFECT_FLAG_DAMAGE_CAL
	)
	e3:SetCountLimit(1,id+3)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={0x0039,0x0030}
s.listed_names={74845897}

--超量召唤手续

--检查卡片是否受到“不能作为超量素材”的效果
function s.xyzlimitcheck(c,xyzc)
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)}
	for _,te in ipairs(eset) do
		local val=te:GetValue()
		if type(val)=="function" then
			if val(te,xyzc) then
				return false
			end
		elseif type(val)=="number" then
			if val~=0 then
				return false
			end
		elseif val then
			return false
		end
	end
	return true
end

--可以用于这张卡超量召唤的素材
function s.xyzfilter(c,xyzc,tp)
	--4星「熔岩」或「大日」怪兽
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup()
			and c:IsCanBeXyzMaterial(xyzc)
			and c:IsXyzLevel(xyzc,4)
			and (
				c:IsSetCard(0x0039)
				or c:IsSetCard(0x0030)
			)
	end
	--自己场上表侧表示、原本类型为魔法或陷阱的「熔岩」卡
	return c:IsControler(tp)
		and c:IsLocation(LOCATION_SZONE)
		and c:IsFaceup()
		and c:IsSetCard(0x0039)
		and (
			c:GetType()
			&(TYPE_SPELL+TYPE_TRAP)
		)~=0
		and c:IsCanOverlay(tp)
		and s.xyzlimitcheck(c,xyzc)
end

function s.getxyzgroup(tp,xyzc,og)
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(
			tp,
			LOCATION_MZONE+LOCATION_SZONE,
			0
		)
	end
	return mg:Filter(s.xyzfilter,nil,xyzc,tp)
end

function s.xyzgoal(g,tp,xyzc)
	if #g~=2 then return false end
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then
		return false
	end
	--处理要求至少使用一定数量素材的效果
	local lg=g:Filter(
		Card.IsHasEffect,
		nil,
		EFFECT_XYZ_MIN_COUNT,
		tp
	)
	local tc=lg:GetFirst()
	while tc do
		local te=tc:IsHasEffect(
			EFFECT_XYZ_MIN_COUNT,
			tp
		)
		if te and #g<te:GetValue() then
			return false
		end
		tc=lg:GetNext()
	end
	return true
end

function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then
		return false
	end
	local tp=c:GetControler()
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	if minc>maxc then return false end

	local mg=s.getxyzgroup(tp,c,og)
	local mustg=Duel.GetMustMaterial(
		tp,
		EFFECT_MUST_BE_XMATERIAL
	)
	if mustg:IsExists(
		Auxiliary.MustMaterialCounterFilter,
		1,
		nil,
		mg
	) then
		return false
	end

	Duel.SetSelectedCard(mustg)
	Auxiliary.GCheckAdditional=
		Auxiliary.TuneMagicianCheckAdditionalXyz
	local res=mg:CheckSubGroup(
		s.xyzgoal,
		minc,
		maxc,
		tp,
		c
	)
	Auxiliary.GCheckAdditional=nil
	return res
end

function s.xyztg(
	e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max
)
	if og and not min then
		return true
	end
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	if minc>maxc then return false end

	local mg=s.getxyzgroup(tp,c,og)
	local mustg=Duel.GetMustMaterial(
		tp,
		EFFECT_MUST_BE_XMATERIAL
	)
	Duel.SetSelectedCard(mustg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)

	local cancel=Duel.IsSummonCancelable()
	Auxiliary.GCheckAdditional=
		Auxiliary.TuneMagicianCheckAdditionalXyz
	local g=mg:SelectSubGroup(
		tp,
		s.xyzgoal,
		cancel,
		minc,
		maxc,
		tp,
		c
	)
	Auxiliary.GCheckAdditional=nil

	if not g then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end

function s.xyzop(
	e,tp,eg,ep,ev,re,r,rp,c,og,min,max
)
	local mg
	local keep=false
	if og and not min then
		mg=og
	else
		mg=e:GetLabelObject()
		keep=true
	end
	if not mg then return end

	--所选素材中有超量怪兽时，
	--将那些超量怪兽原本持有的素材送去墓地
	local exg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		exg:Merge(tc:GetOverlayGroup())
		tc=mg:GetNext()
	end
	if #exg>0 then
		Duel.SendtoGrave(exg,REASON_RULE)
	end

	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	if keep then
		mg:DeleteGroup()
	end
end

--①

--可以代替超量素材取除的装备卡
function s.eqmatfilter(c)
	return c:IsFaceup()
		and c:GetEquipTarget()~=nil
		and c:IsAbleToGrave()
end

--取得自己场上全部可取除卡：
--超量素材＋装备卡
function s.getdetachgroup(tp)
	local g=Duel.GetOverlayGroup(
		tp,
		LOCATION_MZONE,
		0
	)
	g=g:Filter(Card.IsAbleToGrave,nil)

	local eg=Duel.GetMatchingGroup(
		s.eqmatfilter,
		tp,
		LOCATION_SZONE,
		0,
		nil
	)
	g:Merge(eg)
	return g
end

function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
		and (
			c:IsSetCard(0x0039)
			or c:IsSetCard(0x0030)
		)
		and c:IsCanBeSpecialSummoned(
			e,0,tp,false,false
		)
end

--选择组中「熔岩」与「大日」各不能超过1只
function s.spgoal(g)
	return #g>0
		and g:FilterCount(
			Card.IsSetCard,
			nil,
			0x0039
		)<=1
		and g:FilterCount(
			Card.IsSetCard,
			nil,
			0x0030
		)<=1
end

function s.getspmax(tp)
	local ft=Duel.GetLocationCount(
		tp,
		LOCATION_MZONE
	)
	if ft<=0 then return 0 end

	local maxct=math.min(2,ft)
	if maxct>=2
		and not Duel.IsPlayerCanSpecialSummonCount(
			tp,2
		) then
		maxct=1
	end
	return maxct
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=s.getdetachgroup(tp)
	local maxct=s.getspmax(tp)
	local dg=Duel.GetMatchingGroup(
		s.spfilter,
		tp,
		LOCATION_DECK,
		0,
		nil,
		e,
		tp
	)
	if chk==0 then
		return #mg>=2
			and maxct>0
			and dg:CheckSubGroup(
				s.spgoal,
				1,
				maxct
			)
	end
	Duel.SetOperationInfo(
		0,
		CATEGORY_SPECIAL_SUMMON,
		nil,
		maxct,
		tp,
		LOCATION_DECK
	)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	--取除自己场上的2个超量素材
	--装备卡也可以作为超量素材取除
	local mg=s.getdetachgroup(tp)
	if #mg<2 then return end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_REMOVEXYZ
	)
	local rg=mg:Select(tp,2,2,nil)
	if #rg<2 then return end
	if Duel.SendtoGrave(
		rg,
		REASON_EFFECT
	)<2 then
		return
	end

	Duel.BreakEffect()

	local maxct=s.getspmax(tp)
	if maxct<=0 then return end

	local dg=Duel.GetMatchingGroup(
		s.spfilter,
		tp,
		LOCATION_DECK,
		0,
		nil,
		e,
		tp
	)
	if not dg:CheckSubGroup(
		s.spgoal,
		1,
		maxct
	) then
		return
	end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_SPSUMMON
	)
	local sg=dg:SelectSubGroup(
		tp,
		s.spgoal,
		false,
		1,
		maxct
	)
	if sg and #sg>0 then
		Duel.SpecialSummon(
			sg,
			0,
			tp,
			tp,
			false,
			false,
			POS_FACEUP
		)
	end
end

--②

function s.eqtgfilter(c,e,tp)
	return c~=e:GetHandler()
		and c:IsType(TYPE_MONSTER)
		and not c:IsType(TYPE_TOKEN)
		and not c:IsForbidden()
		and (
			c:IsControler(tp)
			or c:IsAbleToChangeControler()
		)
		and c:IsCanBeEffectTarget(e)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(
			LOCATION_MZONE+LOCATION_GRAVE
		)
			and aux.NecroValleyFilter(
				s.eqtgfilter
			)(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(
			aux.NecroValleyFilter(
				s.eqtgfilter
			),
			tp,
			LOCATION_MZONE+LOCATION_GRAVE,
			LOCATION_MZONE+LOCATION_GRAVE,
			1,
			nil,
			e,
			tp
		)
	end
	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_TARGET
	)
	local g=Duel.SelectTarget(
		tp,
		aux.NecroValleyFilter(
			s.eqtgfilter
		),
		tp,
		LOCATION_MZONE+LOCATION_GRAVE,
		LOCATION_MZONE+LOCATION_GRAVE,
		1,
		1,
		nil,
		e,
		tp
	)
	Duel.SetOperationInfo(
		0,
		CATEGORY_EQUIP,
		g,
		1,
		0,
		LOCATION_MZONE+LOCATION_GRAVE
	)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc
		or not tc:IsRelateToEffect(e) then
		return
	end

	--这个回合的结束阶段进行装备处理
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(
		EFFECT_TYPE_FIELD
		+EFFECT_TYPE_CONTINUOUS
	)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(tc)
	e1:SetOperation(s.eqendop)
	e1:SetOwnerPlayer(tp)
	tc:CreateEffectRelation(e1)
	Duel.RegisterEffect(e1,tp)
end

function s.equiptarget(c,tc)
	return c:IsFaceup()
		and c:IsLocation(LOCATION_MZONE)
		and c~=tc
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function s.eqendop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc
		or not tc:IsRelateToEffect(e)
		or not tc:IsLocation(
			LOCATION_MZONE+LOCATION_GRAVE
		)
		or tc:IsType(TYPE_TOKEN)
		or tc:IsForbidden()
		or (
			not tc:IsControler(tp)
			and not tc:IsAbleToChangeControler()
		) then
		return
	end
	if tc:IsLocation(LOCATION_GRAVE)
		and aux.NecroValleyNegateCheck(tc) then
		return
	end
	if Duel.GetLocationCount(
		tp,
		LOCATION_SZONE
	)<=0 then
		return
	end

	local g=Duel.GetMatchingGroup(
		s.equiptarget,
		tp,
		LOCATION_MZONE,
		LOCATION_MZONE,
		nil,
		tc
	)
	if #g==0 then return end

	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_EQUIP
	)
	local ec=g:Select(tp,1,1,nil):GetFirst()
	if not ec then return end

	if not Duel.Equip(tp,tc,ec,true) then
		return
	end

	--只能装备给选择的那只怪兽
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(ec)
	e1:SetValue(s.eqlimit)
	tc:RegisterEffect(e1)

	--装备怪兽的攻击力下降1000
	local e2=Effect.CreateEffect(e:GetOwner())
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end

--③

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(
		EFFECT_FLAG_CARD_TARGET
	) then
		return false
	end
	local g=Duel.GetChainInfo(
		ev,
		CHAININFO_TARGET_CARDS
	)
	return g and g:IsContains(e:GetHandler())
end

function s.thfilter(c)
	return c:IsAbleToHand()
		and (
			(
				c:IsSetCard(0x0030)
				and (
					c:IsType(TYPE_SPELL)
					or c:IsType(TYPE_TRAP)
				)
			)
			or c:IsCode(74845897)
		)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--强制发动，即使卡组中没有对应卡也会建立连锁
	if chk==0 then return true end
	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		nil,
		1,
		tp,
		LOCATION_DECK
	)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(
		HINT_SELECTMSG,
		tp,
		HINTMSG_ATOHAND
	)
	local g=Duel.SelectMatchingCard(
		tp,
		s.thfilter,
		tp,
		LOCATION_DECK,
		0,
		1,
		1,
		nil
	)
	if #g>0
		and Duel.SendtoHand(
			g,
			nil,
			REASON_EFFECT
		)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
