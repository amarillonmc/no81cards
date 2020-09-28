--fate·玉藻喵
function c9951101.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9951101.matfilter,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9951101.efilter)
	c:RegisterEffect(e1)
 --battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951101,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9951101)
	e1:SetCondition(c9951101.thcon)
	e1:SetTarget(c9951101.settg)
	e1:SetOperation(c9951101.setop)
	c:RegisterEffect(e1)
  --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9951101.atkval)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951101.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951101.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951101,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951101,1))
end
function c9951101.matfilter(c)
	return c:IsLinkSetCard(0xba5,0x6ba8) and c:IsType(TYPE_NORMAL)
end
function c9951101.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c9951101.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9951101.setfilter(c,tp)
	local chk=not c:IsControler(tp)
	return c:IsType(TYPE_TRAP) and c:IsSSetable(chk) and (not chk or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c9951101.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9951101.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9951101.setfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9951101.setfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9951101.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end
function c9951101.atkfilter(c)
	return c:IsType(TYPE_NORMAL) 
end
function c9951101.atkval(e,c)
	return Duel.GetMatchingGroup(c9951101.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*1000
end